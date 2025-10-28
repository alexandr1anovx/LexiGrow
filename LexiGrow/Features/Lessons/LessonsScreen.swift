//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI
import SwiftData

struct LessonsScreen: View {
  @Environment(\.modelContext) var modelContext
  @Environment(AuthManager.self) var authManager
  @Environment(LessonsViewModel.self) var viewModel
  
  @State private var selectedLesson: LessonEntity? // for sheet
  @State private var activeLesson: LessonEntity? // for .fullScreenCover
  @State private var displayMode: DisplayMode = .lessons
  
  var body: some View {
    ZStack {
      Color.mainBackground.ignoresSafeArea()
      VStack {
        HStack(spacing: 15) {
          Image(.boy)
            .resizable()
            .frame(width: 30, height: 30)
          Text("Привіт👋, \(authManager.currentUser?.firstName ?? "користувач")!")
            .font(.subheadline)
            .fontWeight(.semibold)
            .fontDesign(.monospaced)
            .lineLimit(1)
        }
        .padding(23)
        
        DisplayModeSelector(displayMode: $displayMode)
        
        Spacer()
        
//        TabView(selection: $displayMode) {
//          GridView(selectedLesson: $selectedLesson)
//            .tag(DisplayMode.lessons)
//          LessonProgressScreen()
//            .tag(DisplayMode.progress)
//        }
//        .tabViewStyle(.page)
        
        Group {
          switch displayMode {
          case .lessons:
            GridView(selectedLesson: $selectedLesson)
              .tag(DisplayMode.lessons)
          case .progress:
            LessonProgressScreen()
              .tag(DisplayMode.progress)
          }
        }
        .transition(.blurReplace)
        
        Spacer()
      }
      .background(.mainBackground)
      .onDisappear {
        // always return user to the first tab
        displayMode = .lessons
      }
      .task {
        await viewModel.syncData(context: modelContext)
      }
      .animation(.spring, value: displayMode)
      .sheet(item: $selectedLesson) { lesson in
        LessonSetupSheet(
          lesson: lesson,
          activeLesson: $activeLesson
        )
      }
      .fullScreenCover(item: $activeLesson) { lesson in
        LessonContainerView(lesson: lesson)
      }
    }
    
  }
}

extension LessonsScreen {
  
  // MARK: Display Mode
  
  enum DisplayMode: String, Identifiable, CaseIterable {
    case lessons = "Уроки"
    case progress = "Прогрес"
    
    var id: Self { self }
    var iconName: String {
      switch self {
      case .lessons: return "book.closed"
      case .progress: return "chart.bar"
      }
    }
  }
  
  // MARK: - Display Mode Selector
  
  struct DisplayModeSelector: View {
    @Binding var displayMode: DisplayMode
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
      HStack(spacing: 8) {
        ForEach(DisplayMode.allCases) { mode in
          ModeButton(mode: mode, isSelected: displayMode == mode) {
            displayMode = mode
            feedbackGenerator.impactOccurred()
          }
        }
      }
      .padding(6)
      .background {
        Capsule()
          .fill(.mainGreen)
          .shadow(radius: 2)
      }
      .padding(.bottom)
    }
  }
  
  // MARK: - Mode Button
  
  /// Stylized button for mode selector
  struct ModeButton: View {
    let mode: DisplayMode
    let isSelected: Bool
    let selectAction: () -> Void
    @State private var shouldAnimate = false
    
    var body: some View {
      Button {
        selectAction()
        if !isSelected {
          shouldAnimate.toggle()
        }
      } label: {
        Label(mode.rawValue, systemImage: isSelected ? "\(mode.iconName).fill" : mode.iconName)
          .symbolEffect(.bounce, value: shouldAnimate)
          .font(.subheadline)
          .foregroundStyle(.white)
          .capsuleLabelStyle(pouring: isSelected ? .lessonCapsule : .clear)
      }
    }
  }
  
  // MARK: - Lessons Grid View
  
  struct GridView: View {
    @Binding var selectedLesson: LessonEntity?
    @Environment(LessonsViewModel.self) var viewModel
    
    private let columns: [GridItem] = [
      GridItem(.flexible()),
      GridItem(.flexible())
    ]
    
    var body: some View {
      if viewModel.isLoading {
        DefaultProgressView()
      } else {
        ScrollView {
          LazyVGrid(columns: columns, spacing: 25) {
            ForEach(viewModel.lessons) { lesson in
              LessonBlockView(lesson: lesson)
                .onTapGesture { selectedLesson = lesson }
            }
          }.padding()
        }
      }
    }
  }
}

struct LessonProgressScreen: View {
  @Query(sort: \LevelProgressEntity.orderIndex)
  private var levelProgressData: [LevelProgressEntity]
  
  @Environment(\.modelContext) private var modelContext
  @Environment(LessonProgressViewModel.self) var viewModel
  
  var body: some View {
    VStack {
      
      List(levelProgressData) {
        
        Cell(
          title: $0.name,
          progress: $0.progress,
          learnedWords: $0.learnedWords,
          totalWords: $0.totalWords
        )
      }
      .listRowSpacing(8)
      .scrollContentBackground(.hidden)
      .refreshable {
        await viewModel.syncProgress(context: modelContext)
      }
    }
    /*
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text("Erase all progress?"),
        message: Text("This action cannot be undone. All your achievements and settings will be deleted."),
        primaryButton: .destructive(Text("Erase")) {
          feedbackGenerator.notificationOccurred(.success)
        },
        secondaryButton: .cancel(Text("Cancel"))
      )
    }
    */
  }
}

extension LessonProgressScreen {
  struct Cell: View {
    let title: String
    let progress: Double
    let learnedWords: Int
    let totalWords: Int
    
    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.headline)
        ProgressView(value: progress)
          .progressViewStyle(.linear)
          .tint(.green)
        HStack(spacing: 3) {
          Text("Learned:")
          Text("\(learnedWords)")
            .foregroundStyle(.accent)
            .fontWeight(.semibold)
          Text("of")
          Text("\(totalWords)")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
      }
    }
  }
}

// MARK: - Sheets and Covers

struct LessonSetupSheet: View {
  @Environment(TranslationViewModel.self) var translationViewModel
  @Environment(\.dismiss) var dismiss
  let lesson: LessonEntity
  @Binding var activeLesson: LessonEntity?
  
  var body: some View {
    Group {
      switch lesson.type {
      case .cards:
        CardsSetupView(lesson: lesson, activeLesson: $activeLesson)
      case .translation:
        TranslationSetupView(viewModel: translationViewModel, lesson: lesson, activeLesson: $activeLesson)
      case .unknown:
        EmptyView()
      }
    }
    .presentationDetents([.fraction(0.5)])
  }
}

/// The container that is displayed in .fullScreenCover
struct LessonContainerView: View {
  @Environment(TranslationViewModel.self) var translationViewModel
  @Environment(\.dismiss) var dismiss
  let lesson: LessonEntity
  
  var body: some View {
    switch lesson.type {
    case .cards:
      CardsContainerView()
    case .translation:
      TranslationView(viewModel: translationViewModel)
    case .unknown:
      VStack {
        Label("Coming Soon", systemImage: "sparkles")
        Button("Dismiss") { dismiss() }
      }
    }
  }
}

#Preview {
  LessonsScreen()
    .environment(CardsViewModel.mock)
    .environment(LessonProgressViewModel.mock)
    .environment(LessonsViewModel.mock)
    .environment(EducationService.mock)
    .environment(AuthManager.mock)
    .environment(TranslationViewModel.mock)
}

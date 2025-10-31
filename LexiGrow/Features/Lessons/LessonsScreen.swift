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
        Text("Привіт👋, \(authManager.currentUser?.firstName ?? "користувач")!")
          .font(.subheadline)
          .fontWeight(.semibold)
          .fontDesign(.monospaced)
          .lineLimit(1)
          .padding(23)
        
        DisplayModeSelector(displayMode: $displayMode)
        
        Spacer()
        
        Group {
          switch displayMode {
          case .lessons:
            GridView(selectedLesson: $selectedLesson)
          case .progress:
            LessonProgressScreen()
          }
        }.transition(.blurReplace)
        
        Spacer()
      }
      .animation(.easeInOut, value: displayMode)
      .onDisappear {
        // always return user to the first tab
        displayMode = .lessons
      }
      .sheet(item: $selectedLesson) { lesson in
        LessonSetupSheet(
          lesson: lesson,
          activeLesson: $activeLesson
        )
      }
      .fullScreenCover(item: $activeLesson) { lesson in
        LessonContainerView(lesson: lesson)
      }
      .task {
        await viewModel.syncData(context: modelContext)
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
      case .lessons: "book.closed"
      case .progress: "chart.bar"
      }
    }
  }
  
  // MARK: - Display Mode Selector
  
  struct DisplayModeSelector: View {
    @Binding var displayMode: DisplayMode
    @State private var triggerSelection = false
    
    var body: some View {
      HStack(spacing: 8) {
        ForEach(DisplayMode.allCases) { mode in
          ModeButton(mode: mode, isSelected: displayMode == mode) {
            displayMode = mode
            triggerSelection.toggle()
          }
          .sensoryFeedback(.selection, trigger: triggerSelection)
        }
      }
      .padding(6)
      .background {
        Capsule()
          .fill(.mainGreen)
          .shadow(radius: 2)
      }.padding(.bottom)
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
          .capsuleLabelStyle(pouring: isSelected ? .mainBrown : .clear)
      }
    }
  }
  
  // MARK: - Lessons Grid View
  
  struct GridView: View {
    @Environment(LessonsViewModel.self) var viewModel
    @Binding var selectedLesson: LessonEntity?
    
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

private struct LessonProgressScreen: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(LessonProgressViewModel.self) var viewModel
  @Query(sort: \LevelProgressEntity.orderIndex)
  private var levelProgressData: [LevelProgressEntity]
  
  var body: some View {
    List(levelProgressData) {
      LessonProgressCell(
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
//    .task { await viewModel.syncProgress(context: modelContext) }
    /*
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text("Erase all progress?"),
        message: Text("This action cannot be undone. All your achievements and settings will be deleted."),
        primaryButton: .destructive(Text("Erase")) {
          
        },
        secondaryButton: .cancel(Text("Cancel"))
      )
    }
    */
  }
}

extension LessonProgressScreen {
  struct LessonProgressCell: View {
    let title: String
    let progress: Double
    let learnedWords: Int
    let totalWords: Int
    
    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        Text(title)
          .font(.headline)
        ProgressView(value: progress)
          .progressViewStyle(.linear)
          .tint(.mainGreen)
        HStack(spacing: 3) {
          Text("Вивчено слів:")
          Text("\(learnedWords)")
            .foregroundStyle(.accent)
            .fontWeight(.semibold)
          Text("з")
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

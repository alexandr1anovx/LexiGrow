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
    NavigationView {
      VStack {
        Text("Hi 👋, \(authManager.currentUser?.username ?? "user")!")
          .font(.title)
          .fontWeight(.bold)
          .padding(.vertical, 20)
          .padding(.horizontal)
        DisplayModeSelector(displayMode: $displayMode)
        TabView(selection: $displayMode) {
          GridView(selectedLesson: $selectedLesson)
            .tag(DisplayMode.lessons)
          StatisticsView()
            .tag(DisplayMode.statistics)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      }
    }
    .sheet(item: $selectedLesson) {
      LessonSetupSheet(lesson: $0, activeLesson: $activeLesson)
    }
    .fullScreenCover(item: $activeLesson) {
      LessonContainerView(lesson: $0)
    }
    .task {
      await viewModel.syncData(context: modelContext)
    }
  }
}

private extension LessonsScreen {
  
  // MARK: Display Mode
  
  enum DisplayMode: String, Identifiable, CaseIterable {
    case lessons = "Lessons"
    case statistics = "Statistics"
    
    var id: Self { self }
    var iconName: String {
      switch self {
      case .lessons: return "book.pages"
      case .statistics: return "chart.bar"
      }
    }
  }
  
  // MARK: - Display Mode Selector
  
  struct DisplayModeSelector: View {
    @Binding var displayMode: DisplayMode
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
      HStack(spacing: 8) {
        ForEach(DisplayMode.allCases) { mode in
          ModeButton(
            title: mode.rawValue,
            icon: mode.iconName,
            isSelected: displayMode == mode
          ) {
            displayMode = mode
            feedbackGenerator.impactOccurred()
          }
        }
      }
      .padding(5)
      .background {
        RoundedRectangle(cornerRadius: 25)
          .fill(.thinMaterial)
          .shadow(radius: 2)
      }
      .padding(.vertical)
    }
  }
  
  // MARK: - Mode Button
  
  /// Stylized button for mode selector
  struct ModeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let selectModeAction: () -> Void
    
    var body: some View {
      Button(action: selectModeAction) {
        Label(title, systemImage: icon)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundStyle(isSelected ? Color(.systemBackground) : .primary)
          .padding(14)
          .background(isSelected ? Color.primary : Color.clear)
          .clipShape(.rect(cornerRadius: 20))
      }
    }
  }
  
  // MARK: - Lessons Grid View
  
  struct GridView: View {
    @Binding var selectedLesson: LessonEntity?
    @Environment(LessonsViewModel.self) var viewModel
    
    private let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 15),
      GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
      Group {
        if viewModel.isLoading {
          CustomProgressView(tint: .pink)
        } else {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 25) {
              ForEach(viewModel.lessons, id: \.id) { lesson in
                LessonBlock(lesson: lesson)
                  .onTapGesture {
                    selectedLesson = lesson
                    print(selectedLesson!)
                  }
              }
            }.padding()
          }
        }
      }
    }
  }
}

struct StatisticsView: View {
  @Query(sort: \LevelProgress.orderIndex) private var levelProgressData: [LevelProgress]
  @Environment(\.modelContext) private var modelContext
  @Environment(StatisticsViewModel.self) var viewModel
  
  var body: some View {
    List(levelProgressData) {
      Cell(
        title: $0.name,
        progress: $0.progress,
        learnedWords: $0.learnedWords,
        totalWords: $0.totalWords
      )
    }
    .refreshable {
      await viewModel.syncProgress(context: modelContext)
    }
    .listStyle(.insetGrouped)
    .overlay {
      if viewModel.isLoading {
        ProgressView()
      }
    }
  }
}

extension StatisticsView {
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
      case .flashcards:
        FlashcardSetupView(lesson: lesson, activeLesson: $activeLesson)
      case .translation:
        TranslationSetupView(viewModel: translationViewModel, lesson: lesson, activeLesson: $activeLesson)
      case .unknown:
        EmptyView()
      }
    }
    .presentationDetents([.fraction(0.5)])
    .presentationCornerRadius(50)
  }
}

/// The container that is displayed in .fullScreenCover
struct LessonContainerView: View {
  @Environment(TranslationViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  let lesson: LessonEntity
  
  var body: some View {
    switch lesson.type {
    case .flashcards:
      FlashcardContainerView()
    case .translation:
      TranslationView(viewModel: viewModel)
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
    .environment(FlashcardViewModel.mockObject)
    .environment(StatisticsViewModel(supabaseService: SupabaseService.mockObject))
    .environment(LessonsViewModel(supabaseService: SupabaseService.mockObject))
    .environment(SupabaseService.mockObject)
    .environment(AuthManager.mockObject)
    .environment(TranslationViewModel.mockObject)
}

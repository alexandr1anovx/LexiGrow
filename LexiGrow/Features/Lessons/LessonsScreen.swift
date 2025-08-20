//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonsScreen: View {
  @Environment(AuthManager.self) var authManager
  @Environment(LessonsViewModel.self) var viewModel
  @State private var selectedLesson: Lesson? // for sheet
  @State private var activeLesson: Lesson? // for .fullScreenCover
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
        .tabViewStyle(.page)
      }
    }
    .sheet(item: $selectedLesson) { lesson in
      LessonSetupSheet(lesson: lesson, activeLesson: $activeLesson)
    }
    .fullScreenCover(item: $activeLesson) { lesson in
      LessonContainerView(lesson: lesson)
    }
    .task {
      await viewModel.getLessons()
    }
  }
}

// MARK: - Display Mode

extension LessonsScreen {
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
}

// MARK: - Subviews

extension LessonsScreen {
  
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
          .shadow(radius: 3)
      }
      .padding(.vertical)
    }
  }
  
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
}


// MARK: - Grid of Lessons

extension LessonsScreen {
  
  struct GridView: View {
    @Binding var selectedLesson: Lesson?
    @Environment(LessonsViewModel.self) var viewModel
    
    private let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 15),
      GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
      Group {
        if viewModel.isLoading {
          GradientProgressView(tint: .pink)
        } else {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 25) {
              ForEach(viewModel.lessons) { lesson in
                LessonBlock(lesson: lesson)
                  .onTapGesture { selectedLesson = lesson }
              }
            }.padding()
          }
        }
      }
    }
  }
}

struct StatisticsView: View {
  @Environment(StatisticsViewModel.self) var viewModel
  
  var body: some View {
    List(viewModel.levelProgressData) { data in
      VStack(alignment: .leading, spacing: 8) {
        Text(data.name)
          .font(.headline)
        ProgressView(value: data.progress)
          .tint(.green)
        Text("Learned: **\(data.learnedWords)** of \(data.totalWords)")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .listStyle(.insetGrouped)
    .listRowSpacing(8)
    .scrollContentBackground(.hidden)
    .task { await viewModel.getLevelProgress() }
  }
}

// MARK: - Sheets and Covers

struct LessonSetupSheet: View {
  @Environment(TranslationViewModel.self) var translationViewModel
  @Environment(FlashcardViewModel.self) var flashcardViewModel
  @Environment(\.dismiss) var dismiss
  let lesson: Lesson
  @Binding var activeLesson: Lesson?
  
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
  let lesson: Lesson
  
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

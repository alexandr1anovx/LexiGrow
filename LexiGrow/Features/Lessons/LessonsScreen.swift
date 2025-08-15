//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonsScreen: View {
  @State private var selectedLesson: Lesson? // for sheet
  @State private var activeLesson: Lesson? // for .fullScreenCover
  @State private var displayMode: DisplayMode = .lessons
  
  var body: some View {
    NavigationView {
      VStack {
        DisplayModeSelector(displayMode: $displayMode)
        TabView(selection: $displayMode) {
          GridView(selectedLesson: $selectedLesson)
            .tag(DisplayMode.lessons)
          StatisticsView()
            .tag(DisplayMode.statistics)
        }
        .tabViewStyle(.page)
      }
      .navigationTitle("Lessons")
      .navigationBarTitleDisplayMode(.large)
    }
    .sheet(item: $selectedLesson) { lesson in
      LessonSetupSheet(lesson: lesson, activeLesson: $activeLesson)
    }
    .fullScreenCover(item: $activeLesson) { lesson in
      LessonContainerView(lesson: lesson)
    }
  }
}

// MARK: - Display Mode

extension LessonsScreen {
  enum DisplayMode: String, Identifiable, CaseIterable {
    case lessons = "Lessons"
    case statistics = "Statistics"
    var id: Self { self }
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
            isSelected: displayMode == mode
          ) {
            displayMode = mode
            feedbackGenerator.impactOccurred()
          }
        }
      }
      .padding(8)
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(.thinMaterial)
          .shadow(radius: 3)
      )
      .padding(.vertical)
    }
  }
  
  /// Stylized button for mode selector
  struct ModeButton: View {
    let title: String
    let isSelected: Bool
    let selectModeAction: () -> Void
    
    var body: some View {
      Button(action: selectModeAction) {
        Text(title)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundStyle(isSelected ? .white : .primary)
          .padding(12)
          .background(
            isSelected ? Color.blue : Color.clear
          )
          .clipShape(.rect(cornerRadius: 16))
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
          HStack {
            Text("Loading lessons...")
            GradientProgressView()
          }
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

  // MARK: - Reusable Progress View

  struct LessonProgressView: View {
    let progress: Double
    let currentIndex: Int
    let totalCount: Int
    
    var body: some View {
      HStack(spacing: 20) {
        ProgressView(value: progress)
          .tint(.blue)
        HStack(spacing: 3) {
          Text("\(currentIndex + 1)")
            .foregroundStyle(.blue)
            .contentTransition(.numericText())
          Text("/")
          Text("\(totalCount)")
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.gray)
      }
      .padding([.top, .horizontal])
    }
  }
}

struct StatisticsView: View {
  @Environment(StatisticsViewModel.self) var viewModel
  
  var body: some View {
    Group {
      if viewModel.isLoading {
        GradientProgressView()
      } else {
        List(viewModel.levelProgressData) { data in
          VStack(alignment: .leading, spacing: 8) {
            Text(data.name)
              .font(.headline)
            ProgressView(value: data.progress)
              .tint(.green)
            Text("Learned: \(data.learnedWords) of \(data.totalWords)")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
        .listStyle(.plain)
        .listRowSpacing(10)
        .scrollContentBackground(.hidden)
      }
    }
    .padding(.vertical)
    .onAppear {
      Task {
        await viewModel.fetchLevelProgress()
      }
    }
  }
}

// MARK: - Sheets and Covers

struct LessonSetupSheet: View {
  @Environment(\.dismiss) var dismiss
  let lesson: Lesson
  @Binding var activeLesson: Lesson?
  @Environment(SupabaseService.self) var supabaseService
  
  var body: some View {
    Group {
      switch lesson.type {
      case .flashcards:
        FlashcardSetupView(
          lesson: lesson,
          activeLesson: $activeLesson
        )
      default:
        ContentUnavailableView {
          Label("Coming Soon", systemImage: "sparkles")
        } description: {
          Text("This lesson isn't available yet.")
        } actions: {
          Button {
            dismiss()
          } label: {
            Text("Dismiss")
              .font(.callout)
              .foregroundStyle(.white)
              .padding(10)
          }
          .prominentButtonStyle(tint: .blue)
        }
      }
    }
    .presentationDragIndicator(.visible)
    .presentationDetents([.fraction(0.45)])
    .presentationCornerRadius(50)
  }
}

/// The container that is displayed in .fullScreenCover
struct LessonContainerView: View {
  @Environment(\.dismiss) var dismiss
  let lesson: Lesson
  
  var body: some View {
    switch lesson.type {
    case .flashcards:
      FlashcardContainerView()
    default:
      ContentUnavailableView {
        Label("Coming Soon", systemImage: "sparkles")
      } description: {
        Text("This lesson isn't available yet.")
      } actions: {
        Button("Return Home") {
          dismiss()
        }
        .font(.headline)
        .tint(.red)
        .buttonStyle(.bordered)
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
}

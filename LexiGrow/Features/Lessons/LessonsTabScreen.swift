//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonsTabScreen: View {
  @State private var selectedLesson: Lesson?
  @State private var activeLesson: Lesson? // for .fullScreenCover
  @State private var displayMode: DisplayMode = .lessons
  
  var body: some View {
    NavigationView {
      VStack {
        DisplayModeSelector(displayMode: $displayMode)
        TabView(selection: $displayMode) {
          LessonsGridView(selectedLesson: $selectedLesson)
            .tag(DisplayMode.lessons)

          // Insert data from view model
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

// MARK: - Supporting Types

extension LessonsTabScreen {
  enum DisplayMode: String, CaseIterable {
    case lessons = "Lessons"
    case statistics = "My statistics"
  }
}

// MARK: - Subviews

extension LessonsTabScreen {
  
  struct DisplayModeSelector: View {
    @Binding var displayMode: DisplayMode
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
      HStack(spacing: 15) {
        Text("Display Mode:")
          .font(.callout)
        HStack(spacing: 8) {
          ForEach(DisplayMode.allCases, id: \.self) { mode in
            ModeButton(
              title: mode.rawValue,
              isSelected: displayMode == mode
            ) {
              displayMode = mode
              feedbackGenerator.impactOccurred()
            }
          }
        }
        .padding(7)
        .background(
          Color.blue.secondary,
          in: RoundedRectangle(cornerRadius: 20)
        )
      }
      .padding(.vertical)
    }
  }
  
  /// Stylized button for mode selector
  struct ModeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
      Button(action: action) {
        Text(title)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundStyle(.white)
          .padding(12)
          .background(
            isSelected ? Color.black.opacity(0.4) : Color.clear
          )
          .clipShape(.rect(cornerRadius: 16))
      }
    }
  }
}


// MARK: - Grid of Lessons

struct LessonsGridView: View {
  @Binding var selectedLesson: Lesson?
  
  private let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 25) {
        ForEach(WordService.lessons) { lesson in
          LessonBlock(lesson: lesson)
            .onTapGesture { selectedLesson = lesson }
        }
      }
      .padding()
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

struct StatisticsView: View {
  @Environment(FlashcardsViewModel.self) var flashcardVM
  var body: some View {
    VStack {
      HStack {
        Text("Known words:")
//        LessonProgressView(
//          progress: flashcardVM.knownWordsProgress,
//          currentIndex: flashcardVM.currentIndex,
//          totalCount: flashcardVM.knownWords.count
//        )
      }
      HStack {
        Text("Unknown words:")
//        LessonProgressView(
//          progress: flashcardVM.unknownWordsProgress,
//          currentIndex: flashcardVM.currentIndex,
//          totalCount: flashcardVM.unknownWords.count
//        )
      }
    }
    .padding(.horizontal)
  }
}

// MARK: - Sheets and Covers

struct LessonSetupSheet: View {
  @Environment(\.dismiss) var dismiss
  let lesson: Lesson
  @Binding var activeLesson: Lesson?
  
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
    .presentationDetents([.fraction(0.5)])
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
    case .guessTheContext:
      GuessTheContextContainerView()
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

// MARK: - Preview

#Preview {
  LessonsTabScreen()
    .environment(FlashcardsViewModel.previewMode)
    .environment(GuessTheContextViewModel.previewMode)
}

//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardsSetupView: View {
  
  let lesson: Lesson
  @Bindable var flashcardViewModel: FlashcardsViewModel
  @State private var flashcardSetupViewModel = FlashcardSetupViewModel()
  @Binding var selectedLessonForFullScreenCover: Lesson?
  @State private var selectedLevel: String?
  @State private var selectedTopic: String?
  @Environment(\.dismiss) private var dismiss
  
  private let levels: [String] = ["B1.1", "B1.2", "B2.1", "B2.2"]
  @State private var availableTopics: [String] = []
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      VStack(spacing: 30) {
        Spacer()
        lessonTitle
        VStack(spacing: 10) {
          FlashcardLevelOptionsView(
            selectedLevel: $selectedLevel,
            selectedTopic: $selectedTopic
          )
          FlashcardTopicSelectionView(
            availableTopics: $availableTopics,
            selectedLevel: $selectedLevel,
            selectedTopic: $selectedTopic
          )
        }
        .padding(.leading)
        FlashcardStartLessonButton(
          lesson: lesson,
          selectedLevel: $selectedLevel,
          selectedTopic: $selectedTopic,
          selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover,
          flashcardViewModel: flashcardViewModel
        )
      }
      .overlay(alignment: .topTrailing) {
        DismissXButton {
          dismiss()
        }.padding(15)
      }
    }
  }
  
  // MARK: - Subviews
  
  private var lessonTitle: some View {
    VStack(spacing: 15) {
      MultiColoredText(text: lesson.name)
        .font(.title)
        .fontWeight(.bold)
        .font(.callout)
      Text("Select a level and topic to start the lesson.")
        .font(.callout)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  FlashcardsSetupView(
    lesson: Lesson.mock,
    flashcardViewModel: FlashcardsViewModel(),
    selectedLessonForFullScreenCover: .constant(.mock)
  )
}

@MainActor
@Observable
final class FlashcardSetupViewModel {
  
  var selectedLevel: String?
  var selectedTopic: String?
  var availableTopics: [String] = []
  private let levels: [String] = ["B1.1", "B1.2", "B2.1", "B2.2"]
  
  private func updateTopicsForSelectedLevel() {
    guard let level = selectedLevel else {
      availableTopics = []
      return
    }
    availableTopics = WordProvider.getTopics(for: level)
  }
  
}

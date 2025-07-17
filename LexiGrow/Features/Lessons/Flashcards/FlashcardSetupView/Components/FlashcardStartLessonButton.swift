//
//  FlashcardStartLessonButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardStartLessonButton: View {
  let lesson: Lesson
  @Binding var selectedLevel: String?
  @Binding var selectedTopic: String?
  @Binding var selectedLessonForFullScreenCover: Lesson?
  @Bindable var flashcardViewModel: FlashcardsViewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    Button {
      if let level = selectedLevel, let topic = selectedTopic {
        flashcardViewModel.startLesson(level: level, topic: topic)
        selectedLessonForFullScreenCover = lesson
        dismiss()
      }
    } label: {
      Label("Start lesson", systemImage: "play.circle.fill")
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .padding(12)
    }
    .tint(.pink)
    .buttonBorderShape(.roundedRectangle(radius: 20))
    .buttonStyle(.borderedProminent)
    .shadow(radius: 10)
    .disabled(selectedLevel == nil || selectedTopic == nil)
  }
}

#Preview {
  FlashcardStartLessonButton(
    lesson: Lesson.mock,
    selectedLevel: .constant("B1.1"),
    selectedTopic: .constant("Eating"),
    selectedLessonForFullScreenCover: .constant(nil),
    flashcardViewModel: FlashcardsViewModel()
  )
}

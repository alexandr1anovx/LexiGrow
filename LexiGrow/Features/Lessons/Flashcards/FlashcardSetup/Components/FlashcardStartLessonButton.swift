//
//  FlashcardStartLessonButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardStartLessonButton: View {
  let lesson: Lesson
  @Binding var selectedLessonForFullScreenCover: Lesson?
  @Environment(FlashcardsViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    Button {
      if let level = viewModel.selectedLevel,
         let topic = viewModel.selectedTopic {
        viewModel.startLesson(level: level, topic: topic)
        selectedLessonForFullScreenCover = lesson
        dismiss()
      }
    } label: {
      Label("Start lesson", systemImage: "play.circle.fill")
        .padding(12)
    }
    .prominentButtonStyle(tint: .pink)
    .disabled(viewModel.selectedLevel == nil || viewModel.selectedTopic == nil)
  }
}

#Preview {
  FlashcardStartLessonButton(
    lesson: Lesson.mock,
    selectedLessonForFullScreenCover: .constant(nil)
  )
}

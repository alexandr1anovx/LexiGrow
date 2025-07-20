//
//  LessonPreview.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FreeLessonPreview: View {
  let lesson: Lesson
  @Binding var selectedLessonForFullScreenCover: Lesson?
  
  var body: some View {
    Group {
      switch lesson.name {
        case "Flashcards":
        FlashcardSetupView(
          lesson: lesson,
          selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover
        )
        .presentationDetents([.fraction(0.48)])
        .presentationCornerRadius(50)
        .presentationBackgroundInteraction(.disabled)
        case "Guess the context":
        GuessTheContextSetupView()
          .presentationCornerRadius(50)
      default:
        EmptyView()
      }
    }
  }
}

#Preview {
  FreeLessonPreview(
    lesson: Lesson.mock,
    selectedLessonForFullScreenCover: .constant(Lesson.mock)
  )
}

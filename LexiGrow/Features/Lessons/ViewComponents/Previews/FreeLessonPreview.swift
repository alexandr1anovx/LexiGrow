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
  @Environment(GuessTheContextViewModel.self) var viewModel
  
  var body: some View {
    Group {
      switch lesson.name {
        
      case "Flashcards":
        FlashcardSetupView(
          lesson: lesson,
          selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover
        )
        .presentationCornerRadius(50)
        
      case "Guess the context":
        GuessTheContextSetupView(
          lesson: lesson,
          selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover
        )
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
  .environment(FlashcardsViewModel())
  .environment(GuessTheContextViewModel())
}

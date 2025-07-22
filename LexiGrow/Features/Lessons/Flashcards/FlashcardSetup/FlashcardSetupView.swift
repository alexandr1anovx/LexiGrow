//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardSetupView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(FlashcardsViewModel.self) var viewModel
  let lesson: Lesson
  @Binding var selectedLessonForFullScreenCover: Lesson?
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor
        .ignoresSafeArea()
      
      VStack(spacing: 30) {
        Spacer()
        lessonTitle
        VStack(spacing: 10) {
          FlashcardLevelOptionsView(viewModel: viewModel)
          FlashcardTopicOptionsView(viewModel: viewModel)
        }
        .padding(.leading)
        FlashcardStartLessonButton(
          lesson: lesson,
          selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover
        )
      }
      .overlay(alignment: .topTrailing) {
        DismissXButton {
          dismiss()
          viewModel.resetSelectedLevelAndTopic()
        }.padding(20)
      }
    }
  }
  
  // MARK: - Subviews
  
  private var lessonTitle: some View {
    VStack(spacing: 15) {
      MultiColoredText(text: lesson.name)
        .font(.title)
        .fontWeight(.bold)
      Text("Select a level and topic to start the lesson.")
        .foregroundStyle(.secondary)
    }
    .font(.callout)
  }
}

#Preview {
  FlashcardSetupView(
    lesson: Lesson.mock,
    selectedLessonForFullScreenCover: .constant(.mock)
  )
}

//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardSetupView: View {
  @Environment(\.dismiss) private var dismiss // hides setup sheet
  @Environment(FlashcardViewModel.self) var viewModel
  let lesson: Lesson // selected lesson
  @Binding var activeLesson: Lesson? // passes the value of the '.fullScreenCover' modifier to the container view.
  
  var body: some View {
    VStack(spacing: 30) {
      Spacer()
      // Title
      VStack(spacing: 8) {
        Label(lesson.name, systemImage: lesson.iconName)
          .font(.title)
          .fontWeight(.bold)
        Text(lesson.description)
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
      
      // Selectable content
      VStack(spacing: 12) {
        LevelsView(viewModel: viewModel)
        TopicsView(viewModel: viewModel)
      }
      .padding(.horizontal)
      
      // Start button
      Button {
        viewModel.startLesson()
        activeLesson = lesson
        dismiss()
      } label: {
        Label("Start lesson", systemImage: "play.circle.fill")
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(!viewModel.canStartLesson)
    }
    .onDisappear {
      viewModel.resetLessonSetupData()
    }
  }
}

#Preview {
  FlashcardSetupView(
    lesson: Lesson.mock,
    activeLesson: .constant(.mock)
  )
  .environment(FlashcardViewModel.mockObject)
}

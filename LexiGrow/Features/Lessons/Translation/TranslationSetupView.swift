//
//  TranslationSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.08.2025.
//

import SwiftUI

struct TranslationSetupView: View {
  @Bindable var viewModel: TranslationViewModel
  @Environment(\.dismiss) var dismiss
  let lesson: Lesson
  @Binding var activeLesson: Lesson?
  
  var body: some View {
    VStack(spacing: 35) {
      Spacer()
      
      VStack(spacing: 8) {
        Label(lesson.name, systemImage: lesson.iconName)
          .font(.title)
          .fontWeight(.bold)
        Text(lesson.description)
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
      
      SelectionScrollView(label: "Levels:") {
        ForEach(viewModel.levels, id: \.self) { level in
          LevelButton(
            name: level.name,
            selectedLevel: $viewModel.selectedLevel) {
              viewModel.selectedLevel = viewModel.selectedLevel == level ? nil : level
            }
        }
      }.padding(.horizontal)
      
      Button {
        Task {
          await viewModel.startLesson()
          activeLesson = lesson
          dismiss()
        }
      } label: {
        Label("Start lesson", systemImage: "play.circle.fill")
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(viewModel.selectedLevel == nil)
    }
    .onAppear {
      viewModel.getLevels()
    }
  }
}

#Preview {
  TranslationSetupView(
    viewModel: TranslationViewModel.mockObject,
    lesson: Lesson.flashcards,
    activeLesson: .constant(Lesson.flashcards)
  )
}

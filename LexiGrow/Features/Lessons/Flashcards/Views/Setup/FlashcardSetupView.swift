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
    NavigationView {
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
        VStack(spacing: 13) {
          LevelsView(viewModel: viewModel)
          TopicsView(viewModel: viewModel)
            .frame(height: 45)
        }
        .padding(.horizontal)
        
        // Start button
        Button {
          viewModel.startLesson()
          activeLesson = lesson
          dismiss()
        } label: {
          Label("Start lesson", systemImage: "play.circle.fill")
            .prominentButtonStyle(tint: .pink)
        }
        .padding([.horizontal, .bottom], 25)
        .disabled(!viewModel.canStartLesson)
        .opacity(!viewModel.canStartLesson ? 0.5 : 1)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          DismissXButton {
            dismiss()
          }
        }
      }
      .onAppear { viewModel.getLevels() }
      .onDisappear { viewModel.resetLessonSetupData() }
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

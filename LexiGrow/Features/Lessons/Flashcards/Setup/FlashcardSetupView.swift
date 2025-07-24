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
      Color.mainBackgroundColor.ignoresSafeArea()
      
      VStack(spacing: 25) {
        Spacer()
        TitleView()
        Divider()
        MainGoalView()
        Divider()
        HowItWorksView()
        Divider()
        VStack(spacing: 10) {
          LevelsView(viewModel: viewModel)
          TopicsView(viewModel: viewModel)
        }
        Spacer()
        StartButton(
          lesson: lesson,
          selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover
        )
      }
      .padding(.horizontal)
      .overlay(alignment: .topTrailing) {
        DismissXButton {
          dismiss()
          viewModel.resetSetupSettings()
        }.padding(20)
      }
    }
  }
}

#Preview {
  FlashcardSetupView(
    lesson: Lesson.mock,
    selectedLessonForFullScreenCover: .constant(.mock)
  )
  .environment(FlashcardsViewModel.previewMode)
}

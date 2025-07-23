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
      
      VStack(spacing: 25) {
        Spacer()
        TitleView()
        Divider()
        MainGoalView()
        Divider()
        HowItWorksView()
        Divider()
        
        VStack(spacing: 10) {
          FlashcardLevelOptionsView(viewModel: viewModel)
          FlashcardTopicOptionsView(viewModel: viewModel)
        }
        Spacer()
        FlashcardStartLessonButton(
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
  ).environment(FlashcardsViewModel())
}


private extension FlashcardSetupView {
  
  struct TitleView: View {
    var body: some View {
      VStack(spacing: 8) {
        HStack(spacing: 0) {
          Text("Flash")
          Text("Cards")
            .foregroundStyle(.pink)
        }
        .font(.title2)
        .fontWeight(.bold)
        Text("Master Your Knowledge, One Card at a Time.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  struct MainGoalView: View {
    var body: some View {
      VStack(spacing: 10) {
        Text("Main Goal")
          .fontWeight(.semibold)
        Text("Reinforce your understanding and memorization of key concepts and information through active recall.")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  struct HowItWorksView: View {
    var body: some View {
      VStack(spacing: 10) {
        Text("How it works ?")
          .fontWeight(.semibold)
        Text("Each flashcard presents a question or a term on one side. Your task is to recall the answer or definition before flipping the card to reveal the correct information. Regularly reviewing these cards will strengthen your memory and help you retain information more effectively.")
          .font(.footnote)
          .foregroundStyle(.secondary)
          .padding(.horizontal,10)
      }
    }
  }
}


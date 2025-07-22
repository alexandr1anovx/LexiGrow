//
//  FlashcardsTryAgainView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardTryAgainView: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor
        .ignoresSafeArea()
      VStack(spacing: 40) {
        TitleView()
        HStack(spacing: 20) {
          ReturnHomeButton()
          TryAgainButton()
        }
      }
    }
  }
}

#Preview {
  FlashcardTryAgainView()
}

private extension FlashcardTryAgainView {
  
  struct TitleView: View {
    var body: some View {
      VStack(spacing: 15) {
        MultiColoredText(text: "Try Again")
          .font(.title)
          .fontWeight(.semibold)
        Text("Would you like to repeat the lesson?")
          .font(.headline)
      }
    }
  }
  
  struct ReturnHomeButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
      Button {
        dismiss()
        viewModel.resetSelectedLevelAndTopic()
      } label: {
        Text("No, return home")
          .padding(11)
      }
      .prominentButtonStyle(
        tint: .cmReversed,
        textColor: .cmSystem
      )
    }
  }
  
  struct TryAgainButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      Button {
        viewModel.startLesson(
          level: viewModel.selectedLevel!,
          topic: viewModel.selectedTopic!
        )
      } label: {
        Text("Yes, try again")
          .padding(11)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
}

//
//  TryAgainButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardSummaryView {
  
  struct TryAgainButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      Button {
        viewModel.startLesson(
          level: viewModel.selectedLevel!,
          topic: viewModel.selectedTopic!
        )
      } label: {
        Label("Try Again", systemImage: "repeat")
          .padding(11)
      }
      .prominentButtonStyle(tint: .indigo)
    }
  }
}

#Preview {
  FlashcardSummaryView.TryAgainButton()
    .environment(FlashcardsViewModel.previewMode)
}

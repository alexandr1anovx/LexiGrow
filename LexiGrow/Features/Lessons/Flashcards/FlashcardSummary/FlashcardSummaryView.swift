//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardSummaryView: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor
        .ignoresSafeArea()
      VStack(spacing: 40) {
        Text("The lesson is over!")
          .font(.title)
          .fontWeight(.bold)
        FlashcardLessonResultView()
        HStack(spacing: 15) {
          FlashcardTryAgainButton()
          FlashcardFinishButton {
            dismiss()
            viewModel.resetSetupSettings()
          }
        }.font(.headline)
      }
    }
  }
}

#Preview {
  FlashcardSummaryView()
    .environment(FlashcardsViewModel())
}

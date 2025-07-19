//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardSummaryView: View {
  @Bindable var viewModel: FlashcardsViewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor
        .ignoresSafeArea()
      VStack(spacing: 40) {
        MultiColoredText(text: "The lesson is over!")
          .font(.title)
          .fontWeight(.bold)
        FlashcardLessonResultView(viewModel: viewModel)
        HStack(spacing: 15) {
          FlashcardTryAgainButton(viewModel: viewModel)
          FlashcardFinishButton { dismiss() }
        }.font(.headline)
      }
    }
  }
}

#Preview {
  FlashcardSummaryView(
    viewModel: FlashcardsViewModel()
  )
}

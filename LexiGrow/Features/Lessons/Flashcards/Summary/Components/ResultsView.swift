//
//  ResultsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardSummaryView {
  
  struct ResultsView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      VStack(spacing: 15) {
        Text("You know: **\(viewModel.knownWordsCount)** / \(viewModel.lessonCards.count) words")
          .font(.title2)
        Text("To repeat: **\(viewModel.repetitionWords.count)** words")
          .font(.title2)
          .foregroundStyle(.gray)
      }
    }
  }
}

#Preview {
  FlashcardSummaryView.ResultsView()
    .environment(FlashcardsViewModel.previewMode)
}

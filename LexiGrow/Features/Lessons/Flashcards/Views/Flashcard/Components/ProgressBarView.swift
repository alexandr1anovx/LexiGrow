//
//  ProgressBarView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct ProgressBar: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 20) {
        ProgressView(value: viewModel.progress)
          .tint(.blue)
        HStack(spacing: 3) {
          Text("\(viewModel.currentIndex + 1)")
            .foregroundStyle(.primary)
            .contentTransition(.numericText())
            .animation(.bouncy, value: viewModel.currentIndex)
          Text("/")
            .foregroundStyle(.secondary)
          Text("\(viewModel.cards.count)")
            .foregroundStyle(.secondary)
        }
        .font(.footnote)
        .fontWeight(.semibold)
      }
      .padding([.top, .horizontal])
    }
  }
}

#Preview {
  FlashcardView.ProgressBar()
    .environment(FlashcardsViewModel.previewMode)
}

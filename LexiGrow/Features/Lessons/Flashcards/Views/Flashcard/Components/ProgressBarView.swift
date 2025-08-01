//
//  ProgressBarView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct ProgressBarView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 20) {
        ProgressView(value: viewModel.progress)
          .tint(.blue)
        HStack(spacing: 3) {
          Text("\(viewModel.currentIndex + 1)")
            .foregroundStyle(.blue)
            .contentTransition(.numericText())
            .animation(.bouncy, value: viewModel.currentIndex)
          Text("/")
          Text("\(viewModel.cards.count)")
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.gray)
      }
      .padding([.top, .horizontal])
    }
  }
}

#Preview {
  FlashcardView.ProgressBarView()
}

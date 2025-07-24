//
//  ProgressBarView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct ProgressBarView: View {
    @Bindable var viewModel: FlashcardsViewModel
    
    var body: some View {
      HStack(spacing: 20) {
        ProgressView(value: viewModel.progress)
          .tint(.pink)
        HStack(spacing: 3) {
          Text("\(viewModel.currentIndex + 1)")
            .foregroundStyle(.pink)
            .contentTransition(.numericText())
            .animation(.bouncy, value: viewModel.currentIndex)
          Text("/")
          Text("\(viewModel.lessonCards.count)")
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
  FlashcardView.ProgressBarView(
    viewModel: FlashcardsViewModel.previewMode
  )
}

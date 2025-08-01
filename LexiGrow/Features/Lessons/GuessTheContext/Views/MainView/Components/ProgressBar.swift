//
//  ProgressBar.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 29.07.2025.
//

import SwiftUI

extension GuessTheContextView {
  
  struct ProgressBar: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
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
          Text("\(viewModel.tasks.count > 0 ? viewModel.tasks.count : 5)")
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.gray)
      }
      .padding()
    }
  }
  
}

#Preview {
  GuessTheContextView.ProgressBar()
    .environment(GuessTheContextViewModel.previewMode)
}

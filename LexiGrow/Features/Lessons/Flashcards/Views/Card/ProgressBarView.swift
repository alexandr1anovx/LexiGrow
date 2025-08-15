//
//  ProgressBarView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct ProgressBar: View {
    @Environment(FlashcardViewModel.self) var viewModel
    
    var body: some View {
      Gauge(value: viewModel.lessonProgress) {
        Text("Index")
      } currentValueLabel: {
        Text("\(viewModel.currentWordIndex + 1)")
          .foregroundStyle(.gray)
      } minimumValueLabel: {
        Text("\(viewModel.currentWordIndex + 1)")
          .foregroundStyle(.gray)
      } maximumValueLabel: {
        Text("\(viewModel.words.count)")
          .foregroundStyle(.gray)
      }
      .tint(.blue)
      .gaugeStyle(.accessoryLinear)
      .padding()  
    }
  }
}

#Preview {
  FlashcardView.ProgressBar()
    .environment(FlashcardViewModel.mockObject)
}

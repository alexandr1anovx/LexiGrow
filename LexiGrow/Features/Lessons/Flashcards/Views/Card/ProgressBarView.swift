//
//  ProgressBarView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension CardView {
  
  struct LessonProgressView: View {
    @Environment(FlashcardViewModel.self) var viewModel
    
    var body: some View {
      Gauge(value: viewModel.lessonProgress) {
        Text("Index")
      } currentValueLabel: {
        Text("\(viewModel.currentWordIndex + 1)")
      } minimumValueLabel: {
        Text("\(viewModel.currentWordIndex + 1)")
      } maximumValueLabel: {
        Text("\(viewModel.words.count)")
      }
      .tint(.blue)
      .gaugeStyle(.accessoryLinear)
      .padding()
    }
  }
}

#Preview {
  CardView.LessonProgressView()
    .environment(FlashcardViewModel.mockObject)
}

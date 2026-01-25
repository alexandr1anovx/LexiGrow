//
//  ProgressBarView.swift
//  ReWord
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct CardLessonProgressView: View {
  @Environment(CardsViewModel.self) var viewModel
  
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
    .tint(.mainGreen)
    .gaugeStyle(.accessoryLinear)
    .padding()
  }
}

#Preview {
  CardLessonProgressView()
    .environment(CardsViewModel.mock)
}

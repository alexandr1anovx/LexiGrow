//
//  GuessTheContextView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.07.2025.
//

import SwiftUI

struct GuessTheContextView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(GuessTheContextViewModel.self) var viewModel
  
  var body: some View {
    VStack {
      ProgressBar()
      Text(viewModel.selectedContext ?? "No context selected")
      Spacer()
      Group {
        if viewModel.currentTask != nil {
          AnswerView()
        } else if let error = viewModel.errorMessage {
          Text(error)
            .foregroundStyle(.red)
          Button("Try again") {
            viewModel.startNewLesson()
          }
          .foregroundStyle(.blue)
          .underline()
        } else if viewModel.isLoading {
          GradientRingProgressView()
        } else {
          GenerateButton()
        }
      }
      Spacer()
    }
  }
}

#Preview {
  GuessTheContextView()
    .environment(GuessTheContextViewModel.previewMode)
}

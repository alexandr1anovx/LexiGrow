//
//  GuessTheContextSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.07.2025.
//

import SwiftUI

struct GuessTheContextSummaryView: View {
  @Environment(GuessTheContextViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    VStack(spacing: 30) {
      Text("Summary:")
        .font(.title)
        .fontWeight(.bold)
      ResultsView()
      HStack(spacing: 10) {
        TryAgainButton()
        ReturnHomeButton {
          dismiss()
        }
      }
    }
  }
}

// MARK: - Subviews

extension GuessTheContextSummaryView {
  
  struct ResultsView: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 3) {
        Text("Correct answers: ")
          .fontWeight(.medium)
        Text("\(viewModel.correctAnswersCount)")
          .fontWeight(.bold)
          .foregroundStyle(.blue)
        Text("/")
        Text("\(viewModel.tasks.count)")
      }
      .font(.title3)
    }
  }
  
  struct TryAgainButton: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
    var body: some View {
      Button {
        viewModel.startNewLesson()
      } label: {
        Label("Try Again", systemImage: "repeat")
          .padding(11)
      }
      .prominentButtonStyle(tint: .white, textColor: .black)
    }
  }
  
  struct ReturnHomeButton: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    var onDismiss: (() -> Void)?
    
    var body: some View {
      Button {
        viewModel.endLesson()
        onDismiss?()
      } label: {
        Text("Return Home")
          .padding(11)
      }
      .prominentButtonStyle(tint: .blue)
    }
  }
  
}

#Preview {
  GuessTheContextSummaryView()
    .environment(GuessTheContextViewModel.previewMode)
}

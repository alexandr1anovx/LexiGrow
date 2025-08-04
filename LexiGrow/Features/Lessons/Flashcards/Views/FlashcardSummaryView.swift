//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardSummaryView: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    VStack(spacing: 30) {
      Text("Words Knowledge Summary:")
        .font(.title2)
        .fontWeight(.bold)
      ResultsView()
      HStack(spacing: 10) {
        TryAgainButton()
        FinishButton { dismiss() }
      }
    }
  }
}

#Preview {
  FlashcardSummaryView()
    .environment(FlashcardsViewModel.previewMode)
}

extension FlashcardSummaryView {
  
  struct ResultsView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 15) {
        Text("Total: \(viewModel.cards.count)")
          .foregroundStyle(.teal)
        Text("|")
          .foregroundStyle(.gray)
        HStack(spacing: 5) {
          Text("Known:")
            .foregroundStyle(.green)
          Text("\(viewModel.knownWords.count)")
        }
        Text("|")
          .foregroundStyle(.gray)
        HStack(spacing: 5) {
          Text("Unknown:")
            .foregroundStyle(.red)
          Text("\(viewModel.unknownWords.count)")
        }
      }
      .fontWeight(.semibold)
    }
  }
  
  struct TryAgainButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      Button {
        viewModel.startLesson()
      } label: {
        Label("Try Again", systemImage: "repeat")
          .padding(11)
      }
      .prominentButtonStyle(tint: .blue)
    }
  }
  
  struct FinishButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    var onDismiss: () -> Void
    
    var body: some View {
      Button {
        onDismiss()
        viewModel.resetSetupSettings()
      } label: {
        Label("Finish", systemImage: "flag.pattern.checkered")
          .padding(11)
      }
      .prominentButtonStyle(tint: .blue)
    }
  }
}

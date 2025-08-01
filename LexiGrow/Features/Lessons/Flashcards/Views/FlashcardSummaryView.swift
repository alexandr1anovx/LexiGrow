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
      Text("Summary:")
        .font(.title)
        .fontWeight(.bold)
      ResultsView()
      HStack(spacing: 10) {
        TryAgainButton()
        ReturnHomeButton { dismiss() }
      }
    }
  }
}

#Preview {
  FlashcardSummaryView()
    .environment(FlashcardsViewModel.previewMode)
}

extension FlashcardSummaryView {
  
  struct TryAgainButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      Button {
        viewModel.startLesson()
      } label: {
        Label("Try Again", systemImage: "repeat")
          .padding(11)
      }
      .prominentButtonStyle(tint: .teal)
    }
  }
}

extension FlashcardSummaryView {
  
  struct ReturnHomeButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    var onDismiss: () -> Void
    
    var body: some View {
      Button {
        onDismiss()
        viewModel.resetSetupSettings()
      } label: {
        Text("Return Home").padding(11)
      }
      .prominentButtonStyle(tint: .blue)
    }
  }
}

extension FlashcardSummaryView {
  
  struct ResultsView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      VStack(spacing: 15) {
        Text("You know: **\(viewModel.knownWordsCount)** / \(viewModel.cards.count) words")
          .font(.title2)
        Text("To repeat: **\(viewModel.unknownWords.count)** words")
          .font(.title2)
          .foregroundStyle(.gray)
      }
    }
  }
}

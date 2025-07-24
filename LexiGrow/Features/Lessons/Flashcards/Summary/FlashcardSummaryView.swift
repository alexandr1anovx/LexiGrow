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
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      
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
}

#Preview {
  FlashcardSummaryView()
    .environment(FlashcardsViewModel.previewMode)
}

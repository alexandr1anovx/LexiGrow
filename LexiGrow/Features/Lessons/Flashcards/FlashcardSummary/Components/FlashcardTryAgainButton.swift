//
//  FlashcardTryAgainButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardTryAgainButton: View {
  @Bindable var viewModel: FlashcardsViewModel
  
  var body: some View {
    Button {
      viewModel.resetLesson()
    } label: {
      Label("Try Again", systemImage: "repeat")
        .padding(11)
    }
    .prominentButtonStyle(tint: .cmReversed, textColor: .cmSystem)
  }
}

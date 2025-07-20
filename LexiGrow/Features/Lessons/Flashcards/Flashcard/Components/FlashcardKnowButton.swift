//
//  KnowButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardKnowButton: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  @Binding var isFlipped: Bool
  
  var body: some View {
    Button {
      viewModel.handleKnown()
      isFlipped = false
    } label: {
      Label("Know", systemImage: "checkmark.seal.fill")
        .padding(11)
    }
    .borderedButtonStyle(tint: .cyan)
  }
}

#Preview {
  FlashcardKnowButton(
    isFlipped: .constant(true)
  )
}

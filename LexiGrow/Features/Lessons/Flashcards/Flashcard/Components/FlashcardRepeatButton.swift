//
//  FlashcardRepeatButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardRepeatButton: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  @Binding var isFlipped: Bool
  
  var body: some View {
    Button {
      viewModel.handleRepeat()
      isFlipped = false
    } label: {
      Label("Repeat", systemImage: "repeat")
        .padding(11)
    }
    .borderedButtonStyle(tint: .cyan)
  }
}

#Preview {
  FlashcardRepeatButton(
    isFlipped: .constant(true)
  )
}

//
//  FlashcardRepeatButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension FlashcardView {
 
  struct RepeatButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    @Binding var isFlipped: Bool
    
    var body: some View {
      Button {
        viewModel.handleRepeat()
        isFlipped = false
      } label: {
        Label("Repeat", systemImage: "repeat")
          .padding(12)
      }
      .borderedButtonStyle(tint: .secondary)
    }
  }
}

#Preview {
  FlashcardView.RepeatButton(isFlipped: .constant(true))
    .environment(FlashcardsViewModel.previewMode)
}

//
//  FlashcardRepeatButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardRepeatButton: View {
  @Binding var isFlipped: Bool
  @Bindable var viewModel: FlashcardsViewModel
  
  init(
    isFlipped: Binding<Bool>,
    viewModel: FlashcardsViewModel
  ) {
    self._isFlipped = isFlipped
    self.viewModel = viewModel
  }
  
  var body: some View {
    Button {
      viewModel.handleRepeat()
      isFlipped = false
    } label: {
      Label("Repeat", systemImage: "repeat")
        .font(.title3)
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .padding(11)
    }
    .tint(.cyan)
    .buttonStyle(.bordered)
    .buttonBorderShape(.capsule)
    .shadow(radius:8)
  }
}

#Preview {
  FlashcardRepeatButton(
    isFlipped: .constant(true),
    viewModel: FlashcardsViewModel()
  )
}

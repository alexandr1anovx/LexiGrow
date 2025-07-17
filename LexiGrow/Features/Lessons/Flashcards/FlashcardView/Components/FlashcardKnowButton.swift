//
//  KnowButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardKnowButton: View {
  @Binding var isFlipped: Bool
  @Bindable var viewModel: FlashcardsViewModel
  
  var body: some View {
    Button {
      viewModel.handleKnown()
      isFlipped = false
    } label: {
      Label("Know", systemImage: "checkmark.seal.fill")
        .font(.title3)
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .padding(10)
    }
    .tint(.cyan)
    .buttonStyle(.bordered)
    .buttonBorderShape(.capsule)
    .shadow(radius:8)
  }
}

#Preview {
  FlashcardKnowButton(
    isFlipped: .constant(true),
    viewModel: FlashcardsViewModel()
  )
}

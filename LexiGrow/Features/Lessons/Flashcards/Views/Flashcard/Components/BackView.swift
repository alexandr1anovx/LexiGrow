//
//  FlashcardBackView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct BackView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    let word: Word
    @Binding var isFlipped: Bool
    
    init(_ word: Word, isFlipped: Binding<Bool>) {
      self.word = word
      self._isFlipped = isFlipped
    }
    
    var body: some View {
      RoundedRectangle(cornerRadius: 40)
        .fill(.blue.gradient)
        .shadow(radius: 3)
        .opacity(isFlipped ? 1 : 0)
        .overlay {
          Text(word.translation)
            .foregroundStyle(.white)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .opacity(isFlipped ? 1 : 0)
        }
        .overlay(alignment: .bottom) {
          HStack {
            ActionButton(
              title: "Don't know",
              systemImage: "repeat",
              tint: .red) {
                viewModel.handleUnknown()
                isFlipped = false
              }
            Spacer()
            ActionButton(
              title: "Know",
              systemImage: "checkmark.seal.fill",
              tint: .green) {
                viewModel.handleKnown()
                isFlipped = false
              }
          }
          .opacity(isFlipped ? 1 : 0)
          .padding(.bottom, 30)
          .padding(.horizontal, 20)
        }
    }
  }
}

#Preview {
  FlashcardView.BackView(Word.mock, isFlipped: .constant(true))
    .environment(FlashcardsViewModel.previewMode)
}

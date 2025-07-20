//
//  FlashcardBackView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardBackView: View {
  let word: Word
  @Binding var isFlipped: Bool
  @Environment(FlashcardsViewModel.self) var viewModel
  
  init(
    _ word: Word,
    isFlipped: Binding<Bool>
  ) {
    self.word = word
    self._isFlipped = isFlipped
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 40)
      .fill(LinearGradient.flashcardBack)
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
          FlashcardRepeatButton(
            isFlipped: $isFlipped
          )
          Spacer()
          FlashcardKnowButton(
            isFlipped: $isFlipped
          )
        }
        .opacity(isFlipped ? 1 : 0)
        .padding([.bottom,.horizontal], 30)
      }
  }
}

#Preview {
  FlashcardBackView(
    Word.mock,
    isFlipped: .constant(true)
  )
  .environment(FlashcardsViewModel())
}

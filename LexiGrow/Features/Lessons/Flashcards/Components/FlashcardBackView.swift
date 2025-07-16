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
  @Bindable var viewModel: FlashcardsViewModel
  
  init(
    _ word: Word,
    isFlipped: Binding<Bool>,
    viewModel: FlashcardsViewModel
  ) {
    self.word = word
    self._isFlipped = isFlipped
    self.viewModel = viewModel
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius:40)
      .fill(LinearGradient.flashcardBack)
      .opacity(isFlipped ? 1 : 0)
      .overlay(alignment: .center) {
        Text(word.translation)
          .foregroundStyle(.white)
          .font(.largeTitle)
          .fontWeight(.semibold)
          .opacity(isFlipped ? 1 : 0)
      }
      .overlay(alignment: .bottom) {
        HStack {
          FlashcardRepeatButton(
            isFlipped: $isFlipped,
            viewModel: viewModel
          )
          Spacer()
          FlashcardKnowButton(
            isFlipped: $isFlipped,
            viewModel: viewModel
          )
        }
        .opacity(isFlipped ? 1 : 0)
        .padding([.bottom,.horizontal], 20)
      }
  }
}

#Preview {
  FlashcardBackView(
    Word.mock,
    isFlipped: .constant(true),
    viewModel: FlashcardsViewModel()
  )
}

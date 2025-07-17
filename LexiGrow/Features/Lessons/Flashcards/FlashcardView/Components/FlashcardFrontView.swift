//
//  FlashcardFrontView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardFrontView: View {
  let word: Word
  @State var cardCounter: Int = 0
  @State var cardOrigin: CGPoint = .zero
  
  init(_ word: Word) {
    self.word = word
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 40)
      .fill(LinearGradient.flashcardFront)
      .onPressingChanged { point in
        if let point {
          cardOrigin = point
          cardCounter += 1
        }
      }
      .modifier(
        RippleEffect(at: cardOrigin, trigger: cardCounter)
      )
      .overlay {
        Text(word.original)
          .font(.largeTitle)
          .fontWeight(.semibold)
          .foregroundStyle(.white)
      }
  }
}

#Preview {
  FlashcardFrontView(Word.mock)
}

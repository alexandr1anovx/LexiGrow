//
//  FlashcardFrontView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardFrontView: View {
  let word: Word
  
  @State var counter: Int = 0
  @State var origin: CGPoint = .zero
  
  var body: some View {
    RoundedRectangle(cornerRadius: 40)
      .fill(LinearGradient.flashcardFront)
      .shadow(radius: 3)
      .overlay {
        Text(word.original)
          .font(.largeTitle)
          .fontWeight(.semibold)
          .foregroundStyle(.white)
          .padding(.horizontal)
          .multilineTextAlignment(.center)
      }
      .onPressingChanged { point in
        if let point {
          origin = point
          counter += 1
        }
      }
      .modifier(
        RippleEffect(at: origin, trigger: counter)
      )
  }
}

#Preview {
  FlashcardFrontView(word: Word.mock)
}

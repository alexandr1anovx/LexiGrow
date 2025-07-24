//
//  FlashcardFrontView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct FrontView: View {
    let word: Word
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    
    var body: some View {
      RoundedRectangle(cornerRadius: 40)
        .fill(.purple)
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
        .modifier(RippleEffect(at: origin, trigger: counter))
    }
  }
}

#Preview {
  FlashcardView.FrontView(word: Word.mock)
    .environment(FlashcardsViewModel.previewMode)
}

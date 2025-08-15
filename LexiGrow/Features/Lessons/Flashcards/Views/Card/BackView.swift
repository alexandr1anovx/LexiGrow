//
//  FlashcardBackView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct BackView: View {
    @Environment(FlashcardViewModel.self) var viewModel
    let word: Word
    @Binding var isFlipped: Bool
    
    init(_ word: Word, isFlipped: Binding<Bool>) {
      self.word = word
      self._isFlipped = isFlipped
    }
    
    var body: some View {
      RoundedRectangle(cornerRadius: 40)
        .fill(Color.card)
        .stroke(
          Color.primary.secondary,
          lineWidth: 3,
          antialiased: true
        )
        .shadow(radius: 3)
        .opacity(isFlipped ? 1:0)
        .overlay {
          Text(word.translation)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .opacity(isFlipped ? 1:0)
        }
        .overlay(alignment: .bottom) {
          HStack {
            Button {
              viewModel.handleUnknown()
              isFlipped = false
            } label: {
              Label("Don't know", systemImage: "xmark.circle.fill")
                .padding(.horizontal,5)
                .padding(.vertical,13)
            }
            .prominentButtonStyle(tint: .red)

            Spacer()
            
            Button {
              viewModel.handleKnown()
              isFlipped = false
            } label: {
              Label("Know", systemImage: "checkmark.circle.fill")
                .padding(.horizontal,5)
                .padding(.vertical,13)
            }
            .prominentButtonStyle(tint: .green)
          }
          .opacity(isFlipped ? 1:0)
          .padding(.bottom, 30)
          .padding(.horizontal, 20)
        }
    }
  }
}

#Preview {
  FlashcardView.BackView(
    Word.mock,
    isFlipped: .constant(true)
  )
  .environment(FlashcardViewModel.mockObject)
}

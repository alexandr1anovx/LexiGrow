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
            RepeatButton(isFlipped: $isFlipped)
            Spacer()
            KnowButton(isFlipped: $isFlipped)
          }
          .opacity(isFlipped ? 1 : 0)
          .padding([.bottom,.horizontal], 30)
        }
    }
  }
}

#Preview {
  FlashcardView.BackView(Word.mock, isFlipped: .constant(true))
    .environment(FlashcardsViewModel.previewMode)
}

extension FlashcardView {
  
  struct KnowButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    @Binding var isFlipped: Bool
    
    var body: some View {
      Button {
        viewModel.handleKnown()
        isFlipped = false
      } label: {
        Label("Know", systemImage: "checkmark.seal.fill")
          .padding(12)
      }
      .borderedButtonStyle(tint: .secondary)
    }
  }
}

//
//  FlashcardBackView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension CardView {
  struct BackCardView: View {
    @Environment(FlashcardViewModel.self) var viewModel
    let word: Word
    @Binding var isFlipped: Bool
    
    var body: some View {
      RoundedRectangle(cornerRadius: 40)
        .fill(Color.systemGray)
        .stroke(Color.systemGray, lineWidth: 2, antialiased: true)
        .shadow(radius: 2)
        .overlay {
          Text(word.translation)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(.blue)
            .padding(.horizontal, 10)
            .multilineTextAlignment(.center)
        }
        .overlay(alignment: .bottomTrailing) {
          Button {
            withAnimation(.easeInOut(duration: 0.6)) {
              isFlipped = false
              viewModel.handleKnownWord()
            }
          } label: {
            Image(systemName: "checkmark")
              .font(.title)
              .capsuleLabelStyle()
          }
          .shadow(radius: 5)
          .padding(50)
        }
        .overlay(alignment: .bottomLeading) {
          Button {
            withAnimation(.easeInOut(duration: 0.6)) {
              isFlipped = false
              viewModel.handleUnknownWord()
            }
          } label: {
            Image(systemName: "xmark")
              .font(.title)
              .capsuleLabelStyle()
          }
          .shadow(radius: 5)
          .padding(50)
        }
    }
  }
}

#Preview {
  CardView.BackCardView(
    word: Word.mock1,
    isFlipped: .constant(true)
  )
  .environment(FlashcardViewModel.mockObject)
}

//
//  CardBackView.swift
//  ReWord
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct CardBackView: View {
  @Environment(CardsViewModel.self) var viewModel
  let word: Word
  @Binding var isFlipped: Bool
  
  var body: some View {
    RoundedRectangle(cornerRadius: 40)
      .fill(.mainGreen)
      .stroke(.white, lineWidth: 2, antialiased: true)
      .shadow(radius: 2)
      .overlay {
        Text(word.translation)
          .font(.largeTitle)
          .fontWeight(.semibold)
          .foregroundStyle(.white)
          .padding(.horizontal)
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
            .padding(2)
            .capsuleLabelStyle(pouring: .mainBrown)
            .foregroundStyle(.white)
        }
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
            .padding(2)
            .capsuleLabelStyle(pouring: .mainBrown)
            .foregroundStyle(.white)
        }
        .padding(50)
      }
  }
}

#Preview {
  CardBackView(word: Word.mock1, isFlipped: .constant(true))
    .environment(CardsViewModel.mock)
}

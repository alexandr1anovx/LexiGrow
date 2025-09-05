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
    
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 40)
          .fill(.thinMaterial)
          .stroke(Color.white, lineWidth: 3, antialiased: true)
          .shadow(radius: 2)
        
        VStack {
          Spacer()
          Text(word.translation)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(.pink)
            .padding(.horizontal, 10)
            .multilineTextAlignment(.center)
          Spacer()
          Button {
            viewModel.handleKnownWord()
            isFlipped = false
          } label: {
            Label("Know", systemImage: "checkmark.circle.fill")
              .prominentButtonStyle(tint: .green)
          }
          Button {
            viewModel.handleUnknownWord()
            isFlipped = false
          } label: {
            Label("Don't know", systemImage: "xmark.circle.fill")
              .prominentButtonStyle(tint: .red)
          }
        }
        .padding([.horizontal, .bottom], 20)
      }
      .opacity(isFlipped ? 1:0)
    }
  }
}

#Preview {
  FlashcardView.BackView(
    word: Word.mock1,
    isFlipped: .constant(true)
  )
  .environment(FlashcardViewModel.mockObject)
}

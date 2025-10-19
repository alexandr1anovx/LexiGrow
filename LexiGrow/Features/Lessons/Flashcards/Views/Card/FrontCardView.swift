//
//  FlashcardFrontView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension CardView {
  struct FrontCardView: View {
    
    // MARK: - Properties
    @Environment(FlashcardViewModel.self) var viewModel
    @State private var animateSoundIcon = false
    let word: Word
    @Binding var isFlipped: Bool
    
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 40)
          .fill(Color.systemGray)
          .stroke(
            Color.systemGray,
            lineWidth: 2,
            antialiased: true
          )
          .shadow(radius: 2)
        VStack(spacing: 30) {
          VStack(spacing: 15) {
            Text(word.original)
              .font(.largeTitle)
              .fontWeight(.semibold)
              .foregroundStyle(.blue)
              .padding(.horizontal)
              .multilineTextAlignment(.center)
            Text("[\(word.transcription)]")
              .font(.title2)
              .fontWeight(.medium)
          }
          
          if #available(iOS 26, *) {
            Button {
              viewModel.speakOriginal()
              animateSoundIcon.toggle()
            } label: {
              Image(systemName: "speaker.wave.2.fill")
                .symbolEffect(.bounce, value: animateSoundIcon)
                .font(.title3)
                .padding(5)
            }
            .tint(.blue)
            .buttonStyle(.glassProminent)
          } else {
            Button {
              viewModel.speakOriginal()
              animateSoundIcon.toggle()
            } label: {
              Image(systemName: "speaker.wave.2.fill")
                .symbolEffect(.bounce, value: animateSoundIcon)
                .font(.title3)
                .padding(5)
                .background(.primary)
                .clipShape(.circle)
            }
          }
        }
      }
    }
  }
}

#Preview {
  CardView.FrontCardView(
    word: Word.mock1,
    isFlipped: .constant(false)
  )
  .environment(FlashcardViewModel.mockObject)
}

//
//  FlashcardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FlashcardView: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  @State private var isShowingExitSheet: Bool = false
  @State private var isFlipped: Bool = false
  @State private var isTurnedAutomaticAudio: Bool = false
  
  var body: some View {
    VStack {
      ProgressBarView()
      
      Toggle("Automatic Sound Playback:", isOn: $isTurnedAutomaticAudio)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        .padding(.top)
      
      if let card = viewModel.currentCard {
        Group {
          if !isFlipped {
            FrontView(
              word: card.word,
              isTurnedAutomaticAudio: $isTurnedAutomaticAudio
            )
          } else {
            BackView(card.word, isFlipped: $isFlipped)
          }
        }
        .onTapGesture {
          isFlipped.toggle()
        }
        .padding(.top, 50)
        .padding(.bottom, 80)
        .padding(.horizontal, 30)
      } else {
        GradientRingProgressView()
      }
    }
  }
}

#Preview {
  FlashcardView()
    .environment(FlashcardsViewModel.previewMode)
}

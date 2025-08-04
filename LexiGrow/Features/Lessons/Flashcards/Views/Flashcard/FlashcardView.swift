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
      ProgressBar()
      HStack {
        KnownWordsView()
        Text("|")
        UnknownWordsView()
      }
      .padding(.vertical)
      
      Toggle("Automatic Sound Playback:", isOn: $isTurnedAutomaticAudio)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
      
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

extension FlashcardView {
  struct UnknownWordsView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 5) {
        Text("Unknown:")
          .font(.subheadline)
          .foregroundStyle(.secondary)
        Text("\(viewModel.unknownWords.count)")
          .contentTransition(.numericText())
          .animation(.bouncy, value: viewModel.currentIndex)
          .font(.callout)
        .fontWeight(.semibold)
      }
    }
  }

  struct KnownWordsView: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 5) {
        Text("Known:")
          .font(.subheadline)
          .foregroundStyle(.secondary)
        Text("\(viewModel.knownWords.count)")
          .contentTransition(.numericText())
          .animation(.bouncy, value: viewModel.currentIndex)
          .font(.callout)
        .fontWeight(.semibold)
      }
    }
  }
}

#Preview {
  FlashcardView()
    .environment(FlashcardsViewModel.previewMode)
}

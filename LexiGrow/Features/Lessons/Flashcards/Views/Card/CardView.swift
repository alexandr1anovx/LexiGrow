//
//  FlashcardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct CardView: View {
  @Environment(FlashcardViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  @AppStorage("automatic_sound_playback") private var isTurnedAudioPlayback = false
  @State private var isFlipped = false
  
  var body: some View {
    VStack {
      if let word = viewModel.currentWord {
        LessonProgressView()
        Toggle(
          "Automatic Sound Playback:",
          systemImage: "speaker.wave.2.fill",
          isOn: $isTurnedAudioPlayback
        )
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        
        HStack(spacing: 10) {
          WordCounterView(
            systemImage: "xmark.circle.fill",
            count: viewModel.unknownWords.count,
            backgroundColor: .indigo
          )
          WordCounterView(
            systemImage: "checkmark.circle.fill",
            count: viewModel.knownWords.count,
            backgroundColor: .indigo
          )
        }.padding(.top)
        
        Group {
          if !isFlipped {
            FrontCardView(word: word, isFlipped: $isFlipped)
              .transition(.slide)
          } else {
            BackCardView(word: word, isFlipped: $isFlipped)
              .transition(.scale)
          }
        }
        .onTapGesture {
          withAnimation(.easeInOut(duration: 0.6)) { isFlipped.toggle() }
        }
        .padding(20)
        .onChange(of: viewModel.currentWordIndex) {
          viewModel.speakCurrentWord(auto: isTurnedAudioPlayback)
        }
        .onAppear {
          viewModel.speakCurrentWord(auto: isTurnedAudioPlayback)
        }
      } else {
        ProgressView("The data is loading...")
      }
    }
  }
}

extension CardView {
  struct WordCounterView: View {
    @Environment(FlashcardViewModel.self) var viewModel
    
    let systemImage: String
    let count: Int
    let backgroundColor: Color
    
    var body: some View {
      HStack {
        Image(systemName: systemImage)
        Text("\(count)")
          .fontWeight(.semibold)
          .monospacedDigit()
          .contentTransition(.numericText())
          .animation(.bouncy, value: viewModel.currentWordIndex)
      }
      .foregroundStyle(.white)
      .padding(15)
      .background {
        Capsule()
          .fill(backgroundColor)
      }
    }
  }
}

#Preview {
  CardView()
    .environment(FlashcardViewModel.mockObject)
}

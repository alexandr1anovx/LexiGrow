//
//  CardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct CardLessonView: View {
  @Environment(CardsViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  @AppStorage("automatic_sound_playback") private var isTurnedAudioPlayback = false
  @State private var isFlipped = false
  
  var body: some View {
    ZStack {
      Color.mainBackground.ignoresSafeArea()
      VStack {
        if let word = viewModel.currentWord {
          CardLessonProgressView()
          Toggle(
            "Озвучувати слова",
            systemImage: "speaker.wave.2.fill",
            isOn: $isTurnedAudioPlayback
          )
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .padding(.horizontal)
          
          HStack(spacing: 10) {
            WordCountView(count: viewModel.unknownWords.count, iconName: "xmark.circle.fill")
            WordCountView(count: viewModel.knownWords.count, iconName: "checkmark.circle.fill")
          }
          .padding(.top)
          
          Group {
            if !isFlipped {
              CardFrontView(word: word, isFlipped: $isFlipped)
                .transition(.slide)
            } else {
              CardBackView(word: word, isFlipped: $isFlipped)
                .transition(.scale)
            }
          }
          .padding(20)
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) { isFlipped.toggle() }
          }
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
    //.background(.mainBackground)
  }
}

extension CardLessonView {
  struct WordCountView: View {
    let count: Int
    let iconName: String
    
    var body: some View {
      Label("\(count)", systemImage: iconName)
        .capsuleLabelStyle(pouring: .primary)
        .monospacedDigit()
        .contentTransition(.numericText())
        .animation(.bouncy, value: count)
        .foregroundStyle(Color.system)
    }
  }
}

#Preview {
  CardLessonView()
    .environment(CardsViewModel.mock)
}

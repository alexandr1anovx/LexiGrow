//
//  CardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct CardLessonView: View {
  @Environment(CardsViewModel.self) var viewModel
  @AppStorage(AppStorageKeys.isAutomaticAudioPlaybackOn) private var isAutomaticAudioPlaybackOn = false
  @State private var isFlipped = false
  
  var body: some View {
    VStack {
      if let word = viewModel.currentWord {
        CardLessonProgressView()
        Toggle(
          "Озвучувати слова",
          systemImage: "speaker.wave.2.fill",
          isOn: $isAutomaticAudioPlaybackOn
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
        .padding(.vertical)
        .onTapGesture {
          withAnimation(.easeInOut(duration: 0.6)) { isFlipped.toggle() }
        }
        .onChange(of: viewModel.currentWordIndex) {
          viewModel.speakCurrentWord(auto: isAutomaticAudioPlaybackOn)
        }
        .onAppear {
          viewModel.speakCurrentWord(auto: isAutomaticAudioPlaybackOn)
        }
      } else {
        ContentUnavailableView("Підготовка карток...", systemImage: "rectangle.stack", description: Text("Завантажуємо слова для вашого уроку. Це займе всього кілька секунд."))
      }
    }
  }
}

private struct WordCountView: View {
  let count: Int
  let iconName: String
  
  var body: some View {
    Label("\(count)", systemImage: iconName)
      .capsuleLabelStyle(pouring: .mainBrown)
      .monospacedDigit()
      .contentTransition(.numericText())
      .animation(.bouncy, value: count)
      .foregroundStyle(.white)
  }
}

#Preview {
  CardLessonView()
    .environment(CardsViewModel.mock)
}

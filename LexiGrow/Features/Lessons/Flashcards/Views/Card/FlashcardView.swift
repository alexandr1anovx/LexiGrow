//
//  FlashcardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FlashcardView: View {
  @Environment(FlashcardViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  @State private var isFlipped = false
  @State private var isTurnedAutomaticAudio = true
  
  var body: some View {
    VStack {
      if let word = viewModel.currentWord {
        LessonProgressView()
        Toggle(
          "Automatic sound playback:",
          systemImage: "speaker.wave.2.fill",
          isOn: $isTurnedAutomaticAudio
        )
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        
        HStack(spacing: 10) {
          WordCounterView(
            systemImage: "xmark.circle.fill",
            count: viewModel.unknownWords.count,
            backgroundColor: .red
          )
          WordCounterView(
            systemImage: "checkmark.circle.fill",
            count: viewModel.knownWords.count,
            backgroundColor: .green
          )
        }
        .padding(.top)
        .shadow(radius: 2)
        
        Group {
          if !isFlipped {
            FrontView(word: word, isFlipped: $isFlipped, isTurnedAutomaticAudio: $isTurnedAutomaticAudio)
          } else {
            BackView(word: word, isFlipped: $isFlipped)
          }
        }
        .onTapGesture {
          isFlipped.toggle()
        }
        .padding(30)
        
        if let error = viewModel.errorMessage {
          Text(error)
            .foregroundStyle(.red)
            .padding(.horizontal)
        }
      } else {
        Text("The data is loading...")
        GradientProgressView()
      }
    }
  }
}

extension FlashcardView {
  
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
        RoundedRectangle(cornerRadius: 20)
          .fill(backgroundColor)
      }
    }
  }
}

#Preview {
  FlashcardView()
    .environment(FlashcardViewModel.mockObject)
}

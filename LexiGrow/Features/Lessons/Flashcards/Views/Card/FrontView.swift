//
//  FlashcardFrontView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct FrontView: View {
    @Environment(FlashcardViewModel.self) var viewModel
    @State private var animateSoundIcon = false
    let word: Word
    @Binding var isFlipped: Bool
    @Binding var isTurnedAudioPlayback: Bool
    
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 40)
          .fill(.thinMaterial)
          .stroke(
            Color(.systemGray5),
            lineWidth: 2,
            antialiased: true
          )
          .shadow(radius: 2)
        
        VStack(spacing: 15) {
          Text(word.original)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(.pink)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
          Text("[\(word.transcription)]")
            .font(.title2)
            .fontWeight(.semibold)
          
          if #available(iOS 26, *) {
            Button {
              viewModel.speakOriginal()
              //audioPlayer.playSound(named: word.audioName)
              animateSoundIcon.toggle()
            } label: {
              Image(systemName: "speaker.wave.2.fill")
                .symbolEffect(.bounce, value: animateSoundIcon)
                .font(.title3)
                .padding(5)
            }
            .buttonStyle(.glass)
            .padding(.top)
          } else {
            Button {
              viewModel.speakOriginal()
              //audioPlayer.playSound(named: word.audioName)
              animateSoundIcon.toggle()
            } label: {
              Image(systemName: "speaker.wave.2.fill")
                .symbolEffect(.bounce, value: animateSoundIcon)
                .foregroundStyle(Color(.systemBackground))
                .font(.title3)
                .padding(5)
                .background(.primary)
                .clipShape(.circle)
            }
            .padding(.top)
          }
        }
      }
//      .onAppear {
//        if isTurnedAutomaticAudio {
//          audioPlayer.playSound(named: word.audioName)
//        }
//      }
    }
  }
}

#Preview {
  FlashcardView.FrontView(
    word: Word.mock1,
    isFlipped: .constant(false),
    isTurnedAudioPlayback: .constant(false)
  )
  .environment(FlashcardViewModel.mockObject)
}

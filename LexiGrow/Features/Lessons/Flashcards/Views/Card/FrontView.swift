//
//  FlashcardFrontView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct FrontView: View {
    @State private var isAnimatingSoundIcon = false
    let word: Word
    @Binding var isFlipped: Bool
    @Binding var isTurnedAutomaticAudio: Bool
    private let audioPlayer = AudioPlayerService()
    
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 40)
          .fill(.thinMaterial)
          .stroke(Color.white, lineWidth: 3, antialiased: true)
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
          Button {
            audioPlayer.playSound(named: word.audioName)
            isAnimatingSoundIcon.toggle()
          } label: {
            Image(systemName: "speaker.wave.2.fill")
              .symbolEffect(.bounce, value: isAnimatingSoundIcon)
              .foregroundStyle(Color(.systemBackground))
              .font(.title3)
              .padding(11)
              .background(.primary)
              .clipShape(.circle)
          }
          .padding(.top)
        }
      }
      .onAppear {
        if isTurnedAutomaticAudio {
          audioPlayer.playSound(named: word.audioName)
        }
      }
    }
  }
}

#Preview {
  FlashcardView.FrontView(
    word: Word.mock,
    isFlipped: .constant(false),
    isTurnedAutomaticAudio: .constant(false)
  )
  .environment(FlashcardViewModel.mockObject)
}

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
    @Binding var isTurnedAutomaticAudio: Bool
    private let audioPlayer = AudioPlayerService()
    
    var body: some View {
      RoundedRectangle(cornerRadius: 40)
        .fill(.blue.gradient)
        .shadow(radius: 3)
        .overlay {
          VStack(spacing: 15) {
            
            Text(word.original)
              .font(.largeTitle)
              .fontWeight(.semibold)
              .foregroundStyle(.yellow)
              .padding(.horizontal)
              .multilineTextAlignment(.center)
            
            Divider()
              .padding(.horizontal,40)
            
            Text("[\(word.transcription)]")
              .font(.title2)
              .fontWeight(.semibold)
              .foregroundStyle(.white)
            
            Button {
              audioPlayer.playSound(named: word.audioName)
              isAnimatingSoundIcon.toggle()
            } label: {
              Image(systemName: "speaker.wave.2.fill")
                .symbolEffect(.bounce, value: isAnimatingSoundIcon)
                .foregroundStyle(.white)
                .font(.title3)
                .padding(10)
                .background(.black.tertiary)
                .clipShape(.circle)
                .shadow(radius: 2)
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
    isTurnedAutomaticAudio: .constant(false)
  )
  .environment(FlashcardViewModel.previewMode)
}

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
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      
      VStack {
        ProgressBarView(viewModel: viewModel)
        if let card = viewModel.currentCard {
          Group {
            if !isFlipped {
              FrontView(word: card.word)
            } else {
              BackView(card.word, isFlipped: $isFlipped)
            }
          }
          .onTapGesture {
            withAnimation(.easeInOut) {
              isFlipped.toggle()
            }
          }
          .padding(30)
        } else {
          ProgressView("Loading Cards...")
        }
      }
    }
  }
}

#Preview {
  FlashcardView()
    .environment(FlashcardsViewModel.previewMode)
}




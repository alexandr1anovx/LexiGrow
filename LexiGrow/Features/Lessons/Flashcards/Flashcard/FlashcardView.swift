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
      Color.mainBackgroundColor
        .ignoresSafeArea()
      VStack {
        HStack(spacing: 20) {
          ProgressView(value: viewModel.progress)
            .tint(.pink)
          HStack(spacing: 3) {
            Text("\(viewModel.currentIndex + 1)")
              .foregroundStyle(.pink)
              .contentTransition(.numericText())
              .animation(.bouncy, value: viewModel.currentIndex)
            Text("/")
            Text("\(viewModel.lessonCards.count)")
          }
          .font(.subheadline)
          .fontWeight(.semibold)
          .foregroundStyle(.gray)
        }
        .padding([.top, .horizontal])
        
        if let card = viewModel.currentCard {
          Group {
            if isFlipped {
              FlashcardBackView(
                card.word,
                isFlipped: $isFlipped
              )
            } else {
              FlashcardFrontView(word: card.word)
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
    .environment(FlashcardsViewModel())
}

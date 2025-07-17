//
//  FlashcardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FlashcardsView: View {
  @Bindable var viewModel: FlashcardsViewModel
  @State private var isShowingExitSheet: Bool = false
  @State private var isFlipped: Bool = false
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
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
                isFlipped: $isFlipped,
                viewModel: viewModel
              )
            } else {
              FlashcardFrontView(card.word)
            }
          }
          .onTapGesture {
            withAnimation {
              isFlipped.toggle()
            }
          }
          .padding(30)
          .shadow(radius: 20)
        } else {
          ProgressView("Loading Cards...")
        }
        Spacer()
        FlashcardShuffleButton()
      }
    }
  }
}

#Preview {
  FlashcardsGroupView(viewModel: FlashcardsViewModel())
}

//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardsSummaryView: View {
  @Bindable var viewModel: FlashcardsViewModel
  var dismissAction: () -> Void
  
  var body: some View {
    ZStack {
      Color.cmSystem.ignoresSafeArea()
      VStack(spacing: 40) {
        title
        lessonResultDescription
        HStack(spacing: 15) {
          tryAgainButton
          finishButton
        }.font(.headline)
      }
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    HStack(spacing: 5) {
      Text("The lesson")
      Text("is over!")
        .foregroundStyle(.pink)
    }
    .font(.title)
    .fontWeight(.bold)
  }
  
  private var lessonResultDescription: some View {
    VStack(spacing: 15) {
      HStack(spacing: 5) {
        Text("You know:")
        Text("\(viewModel.knownWordsCount)")
          .fontWeight(.bold)
          .foregroundStyle(.pink)
        Text("/")
        Text("\(viewModel.lessonCards.count) words")
      }.font(.title2)
      Text("To repeat: **\(viewModel.repetitionWords.count)** words")
        .font(.title2)
        .foregroundStyle(.gray)
    }
  }
  
  private var tryAgainButton: some View {
    Button {
      viewModel.resetLesson()
    } label: {
      Label("Try Again", systemImage: "repeat")
        .padding(11)
        .foregroundStyle(.cmSystem)
    }
    .tint(.cmReversed)
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.roundedRectangle(radius:20))
    .shadow(radius: 10)
  }
  
  private var finishButton: some View {
    Button {
      dismissAction() // returns to the lessons screen
    } label: {
      Label("Finish", systemImage: "flag.pattern.checkered.2.crossed")
        .padding(11)
    }
    .tint(.pink)
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.roundedRectangle(radius:20))
    .shadow(radius: 10)
  }
}

#Preview {
    FlashcardsSummaryView(
      viewModel: FlashcardsViewModel(),
      dismissAction: {}
    )
}

//
//  FlashcardLessonResultView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardLessonResultView: View {
  @Bindable var viewModel: FlashcardsViewModel
  
  var body: some View {
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
}

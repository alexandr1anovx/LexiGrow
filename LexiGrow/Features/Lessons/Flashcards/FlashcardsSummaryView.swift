//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardsSummaryView: View {
  @Bindable var viewModel: FlashcardsViewModel
  
  var body: some View {
    ZStack {
      
      VStack(spacing: 40) {
        Text("The lesson is over!")
          .font(.title)
          .fontWeight(.bold)
        
        VStack(spacing:15) {
          Text("You know: **\(viewModel.knownWordsCount)** words")
            .font(.title2)
            .foregroundStyle(.green)
          Text("Must be repeated: **\(viewModel.repetitionWords.count)** words")
            .font(.title2)
            .foregroundStyle(.orange)
        }
        
        HStack(spacing:10) {
          Button {
            viewModel.resetLesson()
          } label: {
            Label("Try Again", systemImage: "repeat")
              .padding(11)
          }
          .tint(.teal)
          .buttonStyle(.bordered)
          .buttonBorderShape(.capsule)
          Button {
            // go to the main screen
          } label: {
            Label("Finish", systemImage: "flag.pattern.checkered.2.crossed")
              .padding(11)
          }
          .tint(.pink)
          .buttonStyle(.bordered)
          .buttonBorderShape(.capsule)
        }
        .font(.headline)
      }
    }
  }
}

#Preview {
  FlashcardsSummaryView(
    viewModel: FlashcardsViewModel()
  )
}

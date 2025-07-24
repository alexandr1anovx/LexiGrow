//
//  FlashcardLevelOptionsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

extension FlashcardSetupView {
 
  struct LevelsView: View {
    @Bindable var viewModel: FlashcardsViewModel
    
    var body: some View {
      HStack {
        Text("Level:")
        ScrollView(.horizontal) {
          HStack {
            ForEach(viewModel.levels, id: \.self) { level in
              SelectableButton(
                content: level,
                selectedContent: $viewModel.selectedLevel,
                activeColor: .pink) {
                  if viewModel.selectedLevel == level {
                    viewModel.selectedLevel = nil
                  } else {
                    viewModel.selectedLevel = level
                    viewModel.selectedTopic = nil // reset the selected topic
                  }
                }
            }
          }.padding(1)
        }
        .shadow(radius: 3)
        .scrollIndicators(.hidden)
      }
      .font(.callout)
      .fontWeight(.medium)
    }
  }
}

#Preview {
  FlashcardSetupView.LevelsView(
    viewModel: FlashcardsViewModel.previewMode
  )
}

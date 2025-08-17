//
//  FlashcardLevelsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

extension FlashcardSetupView {
  
  struct LevelsView: View {
    @Bindable var viewModel: FlashcardViewModel
    
    var body: some View {
      SelectionScrollView(label: "Levels:") {
        ForEach(viewModel.levels, id: \.self) { level in
          LevelButton(
            name: level.name,
            selectedLevel: $viewModel.selectedLevel
          ) {
            if viewModel.selectedLevel == level {
              viewModel.selectedLevel = nil
            } else {
              viewModel.selectedLevel = level
              viewModel.selectedTopic = nil // discard the selected topic when the level changes.
            }
          }
        }.padding(.leading, 5)
      }
    }
  }
}

#Preview {
  FlashcardSetupView.LevelsView(viewModel: FlashcardViewModel.mockObject)
}

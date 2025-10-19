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
      HStack(spacing: 10) {
        Text("Levels:")
          .font(.subheadline)
          .fontWeight(.medium)
        ScrollView(.horizontal) {
          HStack(spacing: 12) {
            ForEach(viewModel.levels, id: \.id) { level in
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
            }
          }
          .padding(8)
        }
        .scrollIndicators(.hidden)
        .shadow(radius: 2)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 8)
    }
  }
}

#Preview {
  @Previewable @State var levels: [Level] = [.mockB1, .mockB2]
  @Previewable @State var selectedLevel: Level?
  HStack(spacing: 10) {
    Text("Levels:")
      .font(.subheadline)
      .fontWeight(.medium)
    ScrollView(.horizontal) {
      HStack(spacing: 12) {
        ForEach(levels, id: \.self) { level in
          LevelButton(
            name: level.name,
            selectedLevel: $selectedLevel
          ) {
            if selectedLevel == level {
              selectedLevel = nil
            } else {
              selectedLevel = level
            }
          }
        }
        
      }
      .padding(8)
    }
  }
  .frame(maxWidth: .infinity, alignment: .leading)
  .padding(.leading, 8)
}

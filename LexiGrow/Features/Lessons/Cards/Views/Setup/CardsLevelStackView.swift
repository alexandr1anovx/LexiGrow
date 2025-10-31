//
//  CardsLevelStack.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct CardsLevelStackView: View {
  @Bindable var viewModel: CardsViewModel
  
  var body: some View {
    HStack {
      Text("Рівні:")
        .font(.subheadline)
        .fontWeight(.medium)
        .frame(minWidth: 50)
      if viewModel.levels.isEmpty {
        ProgressView("Завантаження рівнів...")
          .foregroundStyle(.gray)
      } else {
        ScrollView(.horizontal) {
          HStack(spacing: 8) {
            ForEach(viewModel.levels) { level in
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
          .padding(3)
        }
        .scrollIndicators(.hidden)
        .shadow(radius: 1)
      }
    }
    .frame(maxWidth: .infinity, minHeight: 45, alignment: .leading)
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
      HStack(spacing: 18) {
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
      .padding(.vertical, 3)
    }.shadow(radius: 1)
  }
  .frame(maxWidth: .infinity, alignment: .leading)
  .padding(.leading, 8)
}

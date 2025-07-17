//
//  FlashcardLevelSelectionButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardLevelButton: View {
  let level: String
  @Binding var selectedLevel: String?
  @Binding var selectedTopic: String?
  
  var body: some View {
    Button {
      if selectedLevel == level {
        selectedLevel = nil
      } else {
        selectedLevel = level
        selectedTopic = nil
      }
    } label: {
      Text(level)
        .font(.headline)
        .padding(15)
        .foregroundColor(.white)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedLevel == level ? .pink : .cmBlack)
            .stroke(selectedLevel == level ? .clear : .white, lineWidth: 2)
        )
    }
  }
}

#Preview {
  FlashcardLevelButton(
    level: "B1.1",
    selectedLevel: .constant("B1.1"),
    selectedTopic: .constant("Eating")
  )
}

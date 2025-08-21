//
//  FlashcardLevelButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct LevelButton: View {
  let name: String
  @Binding var selectedLevel: Level?
  let selectAction: () -> Void
  
  var body: some View {
    Button(action: selectAction) {
      Text(name)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .padding(15)
        .background {
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedLevel?.name == name ? .pink : .black)
            .stroke(
              selectedLevel?.name == name ? .clear : .white,
              lineWidth: 2
            )
            .frame(minWidth: 55)
        }
    }
  }
}

#Preview {
  LevelButton(
    name: "A2",
    selectedLevel: .constant(Level.mockB1),
    selectAction: {}
  )
}

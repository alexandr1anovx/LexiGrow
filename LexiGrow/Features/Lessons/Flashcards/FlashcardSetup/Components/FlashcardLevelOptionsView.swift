//
//  FlashcardLevelOptionsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardLevelOptionsView: View {
  @Binding var selectedLevel: String?
  @Binding var selectedTopic: String?
  private let levels: [String] = ["B1.1", "B1.2", "B2.1", "B2.2"]
  
  var body: some View {
    HStack {
      Text("Level:")
        .font(.headline)
      ScrollView(.horizontal) {
        HStack {
          ForEach(levels, id: \.self) { level in
            FlashcardLevelButton(
              level: level,
              selectedLevel: $selectedLevel,
              selectedTopic: $selectedTopic
            )
          }
        }.padding(5)
      }.shadow(radius: 10)
    }
  }
}

#Preview {
  FlashcardLevelOptionsView(
    selectedLevel: .constant("B1.1"),
    selectedTopic: .constant("Eating")
  )
}

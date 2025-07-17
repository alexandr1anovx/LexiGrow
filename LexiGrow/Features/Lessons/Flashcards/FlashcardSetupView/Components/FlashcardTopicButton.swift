//
//  FlashcardTopicSelectionButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardTopicButton: View {
  let topic: String
  @Binding var selectedTopic: String?
  
  var body: some View {
    Button {
      if selectedTopic == topic {
        selectedTopic = nil
      } else {
        selectedTopic = topic
      }
    } label: {
      Text(topic)
        .font(.headline)
        .padding(15)
        .foregroundColor(.white)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedTopic == topic ? .purple : .cmBlack)
            .stroke(selectedTopic == topic ? .clear : .white, lineWidth: 2)
        )
    }
  }
}

#Preview {
  FlashcardTopicButton(
    topic: "Eating",
    selectedTopic: .constant("Eating")
  )
}

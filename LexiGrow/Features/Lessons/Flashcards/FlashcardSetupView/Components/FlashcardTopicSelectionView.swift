//
//  FlashcardTopicSelectionView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardTopicSelectionView: View {
  @Binding var availableTopics: [String]
  @Binding var selectedLevel: String?
  @Binding var selectedTopic: String?
  
  var body: some View {
    HStack {
      Text("Topic:")
        .font(.headline)
      ScrollView(.horizontal) {
        HStack {
          if selectedLevel != nil && availableTopics.isEmpty {
            Text("No topics available yet")
              .font(.headline)
              .padding(15)
              .foregroundColor(.white)
              .background(
                RoundedRectangle(cornerRadius: 18)
                  .fill(.gray)
              )
          } else if selectedLevel == nil {
            Text("Select a level above")
              .font(.headline)
              .padding(15)
              .foregroundColor(.white)
              .background(
                RoundedRectangle(cornerRadius: 18)
                  .fill(.gray)
              )
          } else {
            ForEach(availableTopics, id: \.self) { topic in
              FlashcardTopicButton(
                topic: topic,
                selectedTopic: $selectedTopic
              )
            }
          }
        }.padding(5)
      }
      .shadow(radius: 10)
      .scrollIndicators(.hidden)
    }
    .onAppear {
      updateTopicsForSelectedLevel()
     }
    .onChange(of: selectedLevel) {
      updateTopicsForSelectedLevel()
      if let topic = selectedTopic,
         !availableTopics.contains(topic) {
        selectedTopic = nil
      }
    }
  }
  
  private func updateTopicsForSelectedLevel() {
    guard let level = selectedLevel else {
      availableTopics = []
      return
    }
    availableTopics = WordProvider.getTopics(for: level)
  }
}

#Preview {
  FlashcardTopicSelectionView(
    availableTopics: .constant(["Eating", "Transportation"]),
    selectedLevel: .constant("B1.1"),
    selectedTopic: .constant("Eating")
  )
}

//
//  TopicButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct TopicButton: View {
  let topic: Topic
  let isSelected: Bool
  let selectAction: () -> Void
  
  private var isCompleted: Bool {
    topic.totalWords > 0 && topic.learnedWords == topic.totalWords
  }
  
  var body: some View {
    Button(action: selectAction) {
      HStack(spacing: 8) {
        Text(topic.name)
          .font(.subheadline)
          .fontWeight(.medium)
        Text("\(topic.learnedWords)/\(topic.totalWords)")
          .font(.caption)
          .fontWeight(.medium)
          .padding(6)
          .background {
            Capsule()
              .fill(isSelected ? .mainGreen : .mainBrown)
          }
      }
      .foregroundColor(.white)
      .padding(12)
      .background {
        Capsule()
          .fill(isSelected ? .mainBrown : .mainGreen)
          .stroke(isSelected ? .white : .clear, lineWidth: 2)
      }
    }
    .disabled(topic.learnedWords == topic.totalWords)
    .opacity(topic.learnedWords == topic.totalWords ? 0.5 : 1)
  }
}

#Preview {
  @Previewable @State var selectedTopic: Topic = .mock1
  let topics: [Topic] = [.mock1, .mock2, .mock3]
  VStack {
    ScrollView(.horizontal) {
      HStack {
        ForEach(topics) { topic in
          TopicButton(
            topic: topic,
            isSelected: selectedTopic == topic) {
              selectedTopic = topic
            }
        }
      }.padding(4)
    }
    .shadow(radius: 1)
    .scrollIndicators(.hidden)
  }
}

//
//  FlashcardTopicButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct TopicButton: View {
  let topic: Topic
  @Binding var selectedTopic: Topic?
  let activeColor: Color
  let selectAction: () -> Void
  
  private var isCompleted: Bool {
    topic.totalWords > 0 && topic.learnedWords == topic.totalWords
  }
  
  var body: some View {
    Button(action: selectAction) {
      HStack(spacing: 10) {
        Text(topic.name)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(.white)
        
        HStack(spacing:0) {
          Text("\(topic.learnedWords)")
            .foregroundStyle(topic.learnedWords != topic.totalWords ? .orange : .white)
          Text("/")
            .foregroundStyle(.white)
          Text("\(topic.totalWords)")
            .foregroundStyle(.white)
        }
        .font(.caption)
        .fontWeight(.semibold)
        .padding(7)
        .background {
          RoundedRectangle(cornerRadius: 10)
            .fill(topic.learnedWords == topic.totalWords ? .green : .olive)
        }
      }
      .padding(12)
      .background {
        RoundedRectangle(cornerRadius: 20)
          .fill(selectedTopic?.id == topic.id ? .pink : .black)
          .stroke(
            selectedTopic?.id == topic.id ? .clear : .white,
            lineWidth: 2
          )
      }
    }
    .disabled(topic.learnedWords == topic.totalWords)
    .opacity(topic.learnedWords == topic.totalWords ? 0.7 : 1)
  }
}

#Preview {
  @Previewable @State var selectedTopic: Topic?
  let topics: [Topic] = [.mock1, .mock2, .mock3]
  
  HStack {
    ForEach(topics, id: \.self) { topic in
      TopicButton(
        topic: Topic(
          id: topic.id,
          name: topic.name,
          totalWords: 20,
          learnedWords: 15
        ),
        selectedTopic: $selectedTopic,
        activeColor: .pink,
        selectAction: {
          selectedTopic = topic
        }
      )
    }
  }
}

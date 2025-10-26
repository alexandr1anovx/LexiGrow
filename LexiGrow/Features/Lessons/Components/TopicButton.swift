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
      HStack(spacing: 10) {
        Text(topic.name)
          .font(.subheadline)
          .fontWeight(.medium)
          
        Text("\(topic.learnedWords)/\(topic.totalWords)")
          .font(.caption)
          .fontWeight(.semibold)
          .padding(6)
          .background {
            Capsule()
              .fill(topic.learnedWords == topic.totalWords ? .orange : .mainYellow)
          }
      }
      .foregroundColor(.white)
      .padding(12)
      .background {
        Capsule()
          .fill(isSelected ? .mainGreen : .topicCapsule)
          .stroke(isSelected ? .clear : .systemGray, lineWidth: 2)
      }
    }
    .disabled(topic.learnedWords == topic.totalWords)
    .opacity(topic.learnedWords == topic.totalWords ? 0.8 : 1)
  }
}

//#Preview {
//  @Previewable @State var selectedTopic: Topic?
//  let topics: [Topic] = [.mock1, .mock2, .mock3]
//  VStack {
//    ScrollView(.horizontal) {
//      HStack {
//        ForEach(topics) { topic in
//          TopicButton(
//            topic: Topic(
//              id: topic.id,
//              name: topic.name,
//              totalWords: topic.totalWords,
//              learnedWords: topic.learnedWords
//            ),
//            selectedTopic: $selectedTopic,
//            activeColor: .pink,
//            selectAction: {
//              selectedTopic = topic
//            }
//          )
//        }
//      }.padding(4)
//    }
//    .shadow(radius: 1)
//    .scrollIndicators(.hidden)
//  }
//}

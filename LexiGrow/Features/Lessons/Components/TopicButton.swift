//
//  FlashcardTopicButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct TopicButton: View {
  let progress: TopicProgress
  @Binding var selectedTopic: Topic?
  let activeColor: Color
  let selectAction: () -> Void
  
  private var isCompleted: Bool {
    progress.totalWords > 0 && progress.learnedWords == progress.totalWords
  }
  
  var body: some View {
    Button(action: selectAction) {
      HStack(spacing: 8) {
        Text(progress.name)
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.white)
        
        HStack(spacing:0) {
          Text("\(progress.learnedWords)")
            .foregroundStyle(progress.learnedWords != progress.totalWords ? .orange : .white)
          Text("/")
            .foregroundStyle(.white)
          Text("\(progress.totalWords)")
            .foregroundStyle(.white)
        }
        .font(.caption)
        .fontWeight(.semibold)
        .padding(7)
        .background {
          RoundedRectangle(cornerRadius: 10)
            .fill(progress.learnedWords == progress.totalWords ? .green : .olive)
        }
      }
      .padding(12)
      .background {
        RoundedRectangle(cornerRadius: 20)
          .fill(selectedTopic?.id == progress.id ? .pink : .black)
          .stroke(
            selectedTopic?.id == progress.id ? .clear : .white,
            lineWidth: 2
          )
      }
    }
    .disabled(progress.learnedWords == progress.totalWords)
    .opacity(progress.learnedWords == progress.totalWords ? 0.7 : 1)
  }
}

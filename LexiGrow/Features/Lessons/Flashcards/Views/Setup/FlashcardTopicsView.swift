//
//  FlashcardTopicsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

extension FlashcardSetupView {
  struct TopicsView: View {
    @Bindable var viewModel: FlashcardViewModel
    
    var body: some View {
      HStack {
        Text("Topics:")
          .font(.subheadline)
          .fontWeight(.medium)
        if viewModel.selectedLevel == nil {
          Text("Select a level above")
            .fontWeight(.medium)
            .foregroundStyle(.gray)
        } else if viewModel.topics.isEmpty {
          Text("No topics yet")
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
        } else {
          ScrollView(.horizontal) {
            HStack(spacing: 5) {
              ForEach(viewModel.sortedTopics, id: \.id) { topic in
                TopicButton(
                  topic: topic,
                  selectedTopic: $viewModel.selectedTopic,
                  activeColor: .pink
                ) {
                  let topicToSelect = Topic(
                    id: topic.id,
                    name: topic.name,
                    totalWords: topic.totalWords,
                    learnedWords: topic.learnedWords
                  )
                  viewModel.selectedTopic = (viewModel.selectedTopic == topicToSelect) ? nil : topicToSelect
                }
              }
            }.padding(8)
          }
          .scrollIndicators(.hidden)
          .shadow(radius: 2)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 8)
      .onChange(of: viewModel.selectedLevel) {
        Task { await viewModel.getTopics() }
      }
    }
  }
}

#Preview {
  FlashcardSetupView.TopicsView(viewModel: .mockObject)
}

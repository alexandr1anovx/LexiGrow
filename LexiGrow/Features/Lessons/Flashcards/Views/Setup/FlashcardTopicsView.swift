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
      SelectionScrollView(label: "Topics:") {
        Group {
          if viewModel.selectedLevel == nil {
            Label("Select a level above", systemImage: "arrow.up.circle.fill")
              .fontWeight(.medium)
              .foregroundStyle(.secondary)
          } else if viewModel.topics.isEmpty {
            Label("No topics for a level above", systemImage: "minus.circle.fill")
              .fontWeight(.medium)
              .foregroundStyle(.secondary)
          } else {
            ForEach(viewModel.sortedTopics, id: \.self) { topic in
              TopicButton(
                topic: topic,
                selectedTopic: $viewModel.selectedTopic,
                activeColor: .pink
              ) {
                let topicToSelect = Topic(id: topic.id, name: topic.name)
                viewModel.selectedTopic = (viewModel.selectedTopic == topicToSelect) ? nil : topicToSelect
              }
            }
          }
        }
        .onChange(of: viewModel.selectedLevel) {
          viewModel.getTopics()
        }
      }
    }
  }
}

#Preview {
  FlashcardSetupView.TopicsView(viewModel: FlashcardViewModel(supabaseService: SupabaseService.mockObject))
}

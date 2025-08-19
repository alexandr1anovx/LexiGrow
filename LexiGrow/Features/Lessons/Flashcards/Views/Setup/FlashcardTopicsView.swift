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
          } else if viewModel.topicsProgress.isEmpty {
            Label("No topics for a level above", systemImage: "minus.circle.fill")
              .fontWeight(.medium)
              .foregroundStyle(.secondary)
          } else {
            ForEach(viewModel.topicsProgress, id: \.self) { progressItem in
              TopicButton(
                progress: progressItem,
                selectedTopic: $viewModel.selectedTopic,
                activeColor: .pink
              ) {
                let topicToSelect = Topic(id: progressItem.id, name: progressItem.name)
                viewModel.selectedTopic = (viewModel.selectedTopic == topicToSelect) ? nil : topicToSelect
              }
              
              
            }
            .scrollIndicators(.hidden)
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

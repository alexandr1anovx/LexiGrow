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
        if viewModel.selectedLevel == nil {
          Text("Select a level above")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.red)
            
        } else if viewModel.topicsProgress.isEmpty {
          Text("No topics for a level above")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.red)
            
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
        }
      }
      .onChange(of: viewModel.selectedLevel) {
        viewModel.getTopics()
      }
    }
  }
}

#Preview {
  FlashcardSetupView.TopicsView(viewModel: FlashcardViewModel(supabaseService: SupabaseService.mockObject))
}

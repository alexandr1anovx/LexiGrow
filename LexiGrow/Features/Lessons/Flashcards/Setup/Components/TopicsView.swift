//
//  FlashcardTopicSelectionView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

extension FlashcardSetupView {
  
  struct TopicsView: View {
    @Bindable var viewModel: FlashcardsViewModel
    
    var body: some View {
      HStack {
        Text("Topic:")
        ScrollView(.horizontal) {
          HStack {
            if viewModel.selectedLevel != nil && viewModel.availableTopics.isEmpty {
              Text("No topics available yet")
                .padding(15)
                .foregroundColor(.white)
                .background(
                  RoundedRectangle(cornerRadius: 20)
                    .fill(.gray)
                )
            } else if viewModel.selectedLevel == nil {
              Text("Select a level above")
                .foregroundColor(.white)
                .padding(15)
                .background(
                  RoundedRectangle(cornerRadius: 20)
                    .fill(.gray.tertiary)
                )
            } else {
              ForEach(viewModel.availableTopics, id: \.self) { topic in
                SelectableButton(
                  content: topic,
                  selectedContent: $viewModel.selectedTopic,
                  activeColor: .purple
                ) {
                  if viewModel.selectedTopic == topic {
                    viewModel.selectedTopic = nil
                  } else {
                    viewModel.selectedTopic = topic
                  }
                }
              }
            }
          }.padding(1)
        }
        .shadow(radius: 3)
        .scrollIndicators(.hidden)
      }
      .font(.callout)
      .fontWeight(.medium)
      
      .onAppear {
        viewModel.resetTopics()
       }
      .onChange(of: viewModel.selectedLevel) {
        viewModel.resetTopics()
        if let topic = viewModel.selectedTopic,
           !viewModel.availableTopics.contains(topic) {
          viewModel.selectedTopic = nil
        }
      }
    }
  }
  
}

#Preview {
  FlashcardSetupView.TopicsView(
    viewModel: FlashcardsViewModel.previewMode
  )
}

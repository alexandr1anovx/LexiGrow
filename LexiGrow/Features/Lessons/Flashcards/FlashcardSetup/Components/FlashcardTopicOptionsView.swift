//
//  FlashcardTopicSelectionView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct FlashcardTopicOptionsView: View {
  @Bindable var viewModel: FlashcardsViewModel
  
  var body: some View {
    HStack {
      Text("Topic:")
        .font(.headline)
      ScrollView(.horizontal) {
        HStack {
          if viewModel.selectedLevel != nil && viewModel.availableTopics.isEmpty {
            Text("No topics available yet")
              .font(.headline)
              .padding(15)
              .foregroundColor(.white)
              .background(
                RoundedRectangle(cornerRadius: 18)
                  .fill(.gray)
              )
          } else if viewModel.selectedLevel == nil {
            Text("Select a level above")
              .font(.headline)
              .padding(15)
              .foregroundColor(.white)
              .background(
                RoundedRectangle(cornerRadius: 15)
                  .fill(.gray.secondary)
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
        }.padding(5)
      }
      .shadow(radius: 3)
      .scrollIndicators(.hidden)
    }
    .onAppear {
      viewModel.updateTopicsForSelectedLevel()
     }
    .onChange(of: viewModel.selectedLevel) {
      viewModel.updateTopicsForSelectedLevel()
      if let topic = viewModel.selectedTopic,
         !viewModel.availableTopics.contains(topic) {
        viewModel.selectedTopic = nil
      }
    }
  }
}

#Preview {
  FlashcardTopicOptionsView(viewModel: FlashcardsViewModel())
}

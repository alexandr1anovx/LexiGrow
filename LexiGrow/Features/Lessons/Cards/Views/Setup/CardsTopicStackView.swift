//
//  CardsTopicStack.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct CardsTopicStackView: View {
  @Bindable var viewModel: CardsViewModel
  @AppStorage(AppStorageKeys.topicSortOption) private var topicSortOption: TopicSortOption = .defaultOrder
  
  var body: some View {
    HStack {
      Text("Теми:")
        .fontWeight(.medium)
        .frame(minWidth: 50)
      
      Menu {
        Picker("Сортувати за", selection: $topicSortOption) {
          ForEach(TopicSortOption.allCases) {
            Text($0.rawValue).tag($0)
          }
        }
      } label: {
        Image(systemName: "line.3.horizontal.decrease")
          .font(.title3)
      }
      .onChange(of: topicSortOption) { _, newTopic in
        viewModel.topicSortOption = newTopic
      }
      
      if viewModel.selectedLevel == nil {
        Text("Потрібно обрати рівень.")
          .foregroundStyle(.gray)
      } else if viewModel.topics.isEmpty {
        Text("Наразі відсутні теми для цього рівня.")
          .foregroundStyle(.gray)
      } else {
        ScrollView(.horizontal) {
          HStack(spacing: 6) {
            ForEach(viewModel.sortedTopics, id: \.id) { topic in
              TopicButton(topic: topic, isSelected: viewModel.selectedTopic == topic) {
                viewModel.selectedTopic = (viewModel.selectedTopic == topic) ? nil : topic
              }
            }
          }.padding(3)
        }
        .scrollIndicators(.hidden)
        .shadow(radius: 1)
      }
    }
    .font(.subheadline)
    .frame(maxWidth: .infinity, minHeight: 45, alignment: .leading)
    .task(id: viewModel.selectedLevel) {
      await viewModel.getTopics()
    }
  }
}

#Preview {
  CardsTopicStackView(viewModel: .mock)
}

//
//  CardsTopicStack.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct CardsTopicStackView: View {
  @Bindable var viewModel: CardsViewModel
  
  var body: some View {
    HStack {
      Text("Теми:")
        .font(.subheadline)
        .fontWeight(.medium)
      
      Menu {
        ForEach(viewModel.sortedTopics) { topic in
          Button {
            viewModel.selectedTopic = (viewModel.selectedTopic == topic) ? nil : topic
          } label: {
            Label(topic.name, systemImage: viewModel.selectedTopic == topic ? "checkmark.circle.fill" : "circle")
          }
        }
      } label: {
        Image(systemName: "chevron.up.chevron.down")
      }
      .padding(.leading, 8)
      .disabled(viewModel.selectedLevel == nil)
      .opacity(viewModel.selectedLevel == nil ? 0.5:1)
      
      if viewModel.selectedLevel == nil {
        Text("Оберіть тему вище")
          .foregroundStyle(.gray)
      } else if viewModel.topics.isEmpty {
        Text("Немає тем")
          .foregroundStyle(.gray)
      } else {
        ScrollView(.horizontal) {
          HStack(spacing: 5) {
            ForEach(viewModel.sortedTopics, id: \.id) { topic in
              TopicButton(topic: topic, isSelected: viewModel.selectedTopic == topic) {
                viewModel.selectedTopic = (viewModel.selectedTopic == topic) ? nil : topic
              }
            }
          }.padding(8)
        }
        .scrollIndicators(.hidden)
        .shadow(radius: 1)
      }
    }
    .font(.subheadline)
    .frame(maxWidth: .infinity, alignment: .leading)
    .onChange(of: viewModel.selectedLevel) {
      Task { await viewModel.getTopics() }
    }
  }
}

//#Preview {
//  CardsTopicStackView(viewModel: .mock)
//}

#Preview {
  CardsSetupView(
    lesson: .mock,
    activeLesson: .constant(.mock)
  )
  .environment(CardsViewModel.mock)
}

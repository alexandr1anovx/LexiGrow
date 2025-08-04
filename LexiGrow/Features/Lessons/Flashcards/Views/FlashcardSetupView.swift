//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//


import SwiftUI

struct FlashcardSetupView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(FlashcardsViewModel.self) var viewModel
  let lesson: Lesson
  @Binding var activeLesson: Lesson?
  
  var body: some View {
    NavigationView {
      VStack(spacing: 35) {
        TitleView(for: lesson)
        VStack(spacing: 10) {
          LevelsView(viewModel: viewModel)
          TopicsView(viewModel: viewModel)
        }
        .padding(.horizontal)
        StartButton {
          viewModel.startLesson()
          activeLesson = lesson
          dismiss()
        }
      }
      .toolbar {
        ToolbarItem(placement: .destructiveAction) {
          DismissXButton {
            dismiss()
            viewModel.resetSetupSettings()
          }.padding(.top)
        }
      }
    }
  }
}

private extension FlashcardSetupView {
  
  // MARK: - Title View
  
  struct TitleView: View {
    let lesson: Lesson
    init(for lesson: Lesson) {
      self.lesson = lesson
    }
    var body: some View {
      VStack(spacing: 8) {
        Label(lesson.name, systemImage: lesson.iconName)
          .font(.system(size: 25))
          .fontWeight(.bold)
        Text(lesson.description)
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  // MARK: - Start Button
  
  struct StartButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    var action: () -> Void
    
    var body: some View {
      Button(action: action) {
        Label("Start lesson", systemImage: "play.circle.fill")
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(viewModel.isStartDisabled)
    }
  }
  
  // MARK: - Levels View
  
  struct LevelsView: View {
    @Bindable var viewModel: FlashcardsViewModel
    
    var body: some View {
      SelectionScrollView(label: "Level:") {
        ForEach(viewModel.levels, id: \.self) { level in
          LevelButton(
            name: level,
            selectedLevel: $viewModel.selectedLevel,
            activeColor: .teal
          ) {
              if viewModel.selectedLevel == level {
                viewModel.selectedLevel = nil
              } else {
                viewModel.selectedLevel = level
                viewModel.selectedTopic = nil // reset the selected topic
              }
            }
        }
      }
    }
  }
  
  // MARK: - Topics View
  
  struct LevelButton: View {
    let name: String
    @Binding var selectedLevel: String?
    let activeColor: Color
    let action: () -> Void
    
    var body: some View {
      Button {
        action()
      } label: {
        Text(name)
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.white)
          .padding(15)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(selectedLevel == name ? activeColor : .black)
              .stroke(selectedLevel == name ? .clear : .white, lineWidth: 2)
        )
      }
    }
  }
  
  struct TopicButton: View {
    let name: String
    @Binding var selectedTopic: String?
    let activeColor: Color
    let action: () -> Void
    
    var body: some View {
      Button {
        action()
      } label: {
        Text(name)
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.white)
          .padding(15)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(selectedTopic == name ? activeColor : .black)
              .stroke(selectedTopic == name ? .clear : .white, lineWidth: 2)
          )
      }
    }
  }
  
  struct TopicsView: View {
    @Bindable var viewModel: FlashcardsViewModel
    
    var body: some View {
      SelectionScrollView(label: "Topic:") {
        if viewModel.selectedLevel == nil {
          Text("Select a level above")
            .foregroundColor(.white)
            .padding(15)
            .background(.gray)
            .clipShape(.capsule)
        } else {
          ForEach(viewModel.topics, id: \.self) { topic in
            TopicButton(
              name: topic,
              selectedTopic: $viewModel.selectedTopic,
              activeColor: .teal
            ) {
              viewModel.selectedTopic = (viewModel.selectedTopic == topic) ? nil : topic
            }
          }
        }
      }
      .onAppear {
        viewModel.resetTopics()
        viewModel.getLevels()
      }
      .onChange(of: viewModel.selectedLevel) {
        viewModel.resetTopics()
      }
    }
  }
}

struct SelectionScrollView<Content: View>: View {
  
  let label: String
  @ViewBuilder let content: Content
  
  var body: some View {
    HStack {
      Text(label)
      ScrollView(.horizontal) {
        HStack {
          content
        }
        .padding(1)
      }
      .shadow(radius: 3)
      .scrollIndicators(.hidden)
    }
    .font(.callout)
    .fontWeight(.medium)
  }
}

#Preview {
  FlashcardSetupView(
    lesson: Lesson.mock,
    activeLesson: .constant(.mock)
  )
  .environment(FlashcardsViewModel.previewMode)
}

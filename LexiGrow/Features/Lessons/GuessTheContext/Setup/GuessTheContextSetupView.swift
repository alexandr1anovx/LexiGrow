//
//  GuessTheContextSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 20.07.2025.
//

import SwiftUI

struct GuessTheContextSetupView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(GuessTheContextViewModel.self) var viewModel
  let lesson: Lesson
  @Binding var selectedLessonForFullScreenCover: Lesson?
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor
        .ignoresSafeArea()
      
      VStack(spacing: 25) {
        Spacer()
        TitleView()
        Divider()
        MainGoalView()
        Divider()
        HowItWorksView()
        Divider()
        SelectTheContextView(viewModel: viewModel)
        
        Spacer()
        
        Button {
          viewModel.startLesson(context: viewModel.selectedContext!)
          selectedLessonForFullScreenCover = lesson
          dismiss()
        } label: {
          Label("Start Lesson", systemImage: "play.circle.fill")
            .padding(12)
        }
        .prominentButtonStyle(tint: .pink)
        .disabled(viewModel.selectedContext == nil)
      }
      .padding(.horizontal)
      .overlay(alignment: .topTrailing) {
        DismissXButton {
          dismiss()
        }.padding(20)
      }
    }
  }
}

#Preview {
  GuessTheContextSetupView(
    lesson: Lesson.mock,
    selectedLessonForFullScreenCover: .constant(.mock)
  )
  .environment(GuessTheContextViewModel())
}

private extension GuessTheContextSetupView {
  
  struct TitleView: View {
    var body: some View {
      VStack(spacing: 10) {
        HStack(spacing: 5) {
          Text("Guess")
          Text("The")
          Text("Context")
            .foregroundStyle(.pink)
        }
        .font(.title2)
        .fontWeight(.bold)
        Text("Master Reading Between the Lines.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  struct MainGoalView: View {
    var body: some View {
      VStack(spacing: 10) {
        Text("Main Goal")
          .fontWeight(.semibold)
        Text("Sharpen your ability to understand unspoken cues and implied meanings in conversations and situations.")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  struct HowItWorksView: View {
    var body: some View {
      VStack(spacing: 10) {
        Text("How it works ?")
          .fontWeight(.semibold)
        Text("This lesson presents you with various real-world scenarios, from short dialogues to brief descriptions of events. Your task is to analyze the provided information and then select the most appropriate underlying context from a set of choices. Each correct answer helps you fine-tune your intuition and develop a deeper understanding of social dynamics.")
          .font(.footnote)
          .foregroundStyle(.secondary)
          .padding(.horizontal, 10)
      }
    }
  }
  
  struct SelectTheContextView: View {
    @Bindable var viewModel: GuessTheContextViewModel
    
    var body: some View {
      HStack {
        Text("Context:")
          .fontWeight(.medium)
        ScrollView(.horizontal) {
          HStack {
            ForEach(viewModel.contexts, id: \.self) { context in
              SelectableButton(
                content: context,
                selectedContent: $viewModel.selectedContext,
                activeColor: .pink) {
                  if viewModel.selectedContext == context {
                    viewModel.selectedContext = nil
                  } else {
                    viewModel.selectedContext = context
                  }
                }
            }
          }.padding(1)
        }
        .shadow(radius: 3)
        .scrollIndicators(.hidden)
      }
    }
  }
  
}

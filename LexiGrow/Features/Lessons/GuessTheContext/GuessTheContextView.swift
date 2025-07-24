//
//  GuessTheContextView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.07.2025.
//

import SwiftUI

struct GuessTheContextView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(GuessTheContextViewModel.self) var viewModel
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      
      VStack {
        Text(viewModel.selectedContext ?? "No Selected Context")
          .fontWeight(.bold)
          .padding(5)
        ProgressBarView()
        
        Group {
          if viewModel.isLoading {
            ProgressView("Generating...")
          } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
              .foregroundStyle(.red)
          } else if viewModel.currentTask != nil {
            AnswerView()
          } else {
            if let context = viewModel.selectedContext {
              GenerateTextButton(context: context)
            } else {
              Text("Please select a context first.")
            }
          }
        }
        Spacer()
      }
    }
  }
}

#Preview {
  GuessTheContextView()
    .environment(GuessTheContextViewModel.previewMode)
}

// MARK: - Generated Answer View

private extension GuessTheContextView {
  
  struct ProgressBarView: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
    var body: some View {
      HStack(spacing: 20) {
        ProgressView(value: viewModel.progress)
          .tint(.pink)
        HStack(spacing: 3) {
          Text("\(viewModel.currentIndex + 1)")
            .font(.headline)
            .foregroundStyle(.pink)
            .contentTransition(.numericText())
            .animation(.bouncy, value: viewModel.currentIndex)
          Text("/")
          Text("\(viewModel.tasks.count > 0 ? viewModel.tasks.count : 5)")
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.gray)
      }
      .padding()
    }
  }
  
  struct GenerateTextButton: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    let context: String
    
    var body: some View {
      Button {
        viewModel.startNewLesson(context: context)
      } label: {
        Label("Generate Text", systemImage: "sparkles")
          .padding(12)
          .fontWeight(.semibold)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
  
  
  struct AnswerView: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
    var columns: [GridItem] = [
      GridItem(.flexible(minimum: 120, maximum: 200))
    ]
    
    var body: some View {
      if let task = viewModel.currentTask {
        VStack(spacing: 20) {
          Text(task.text)
            .fontWeight(.medium)
            .padding()
          LazyVGrid(columns: columns, spacing: 10) {
            ForEach(task.answers) { answer in
              Button {
                viewModel.selectAnswer(answer)
              } label: {
                Text(answer.text)
                  .font(.callout)
                  .fontWeight(.medium)
                  .foregroundColor(.white)
                  .padding(15)
                  .background(
                    RoundedRectangle(cornerRadius: 20)
                      .fill(viewModel.buttonColor(answer: answer))
                      .stroke(.white, lineWidth: 2)
                  )
              }
            }
          }.shadow(radius: 3)
        }
      }
    }
  }
  
}

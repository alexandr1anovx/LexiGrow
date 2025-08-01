//
//  AnswerView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 29.07.2025.
//

import SwiftUI

extension GuessTheContextView {
  
  struct AnswerView: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
    private let columns: [GridItem] = [
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

#Preview {
  GuessTheContextView.AnswerView()
    .environment(GuessTheContextViewModel.previewMode)
}

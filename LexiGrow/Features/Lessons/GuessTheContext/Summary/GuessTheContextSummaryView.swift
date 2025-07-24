//
//  GuessTheContextSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.07.2025.
//

import SwiftUI

struct GuessTheContextSummaryView: View {
  @Environment(GuessTheContextViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      
      VStack(spacing: 25) {
        Text("Guess The Context")
          .font(.title)
          .fontWeight(.bold)
          .fontDesign(.monospaced)
        
        // Results
        HStack(spacing: 3) {
          Text("Correct answers: ")
            .fontWeight(.medium)
            
          Text("\(viewModel.correctAnswersCount)")
            .fontWeight(.bold)
            .foregroundStyle(.pink)
          Text("/")
          Text("\(viewModel.tasks.count)")
        }
        .font(.title3)
        .fontDesign(.monospaced)
        
        // Buttons
        
        HStack(spacing: 15) {
          Button {
            viewModel.startNewLesson(context: viewModel.selectedContext!)
          } label: {
            Label("Try Again", systemImage: "repeat")
              .padding(11)
          }
          .prominentButtonStyle(
            tint: .cmReversed,
            textColor: .cmSystem
          )
          
          Button {
            dismiss()
          } label: {
            Text("Return Home")
              .padding(11)
          }
          .prominentButtonStyle(tint: .pink)
        }.padding(.top)
      }
    }
  }
}

#Preview {
  GuessTheContextSummaryView()
    .environment(
      GuessTheContextViewModel.previewMode
    )
}

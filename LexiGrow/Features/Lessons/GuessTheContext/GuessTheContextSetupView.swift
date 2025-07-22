//
//  GuessTheContextSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 20.07.2025.
//

import SwiftUI


struct GuessTheContextSetupView: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor
        .ignoresSafeArea()
      VStack(spacing: 30) {
        
        Spacer()
        
        // MARK: - Title
        
        VStack(spacing:8) {
          Text("Guess the Context:")
            .font(.title2)
            .fontWeight(.black)
            .foregroundStyle(.pink)
          Text("Master Reading Between the Lines.")
            .fontWeight(.medium)
        }
        
        Divider()
        
        // MARK: - Main Goal
        
        VStack(alignment: .center, spacing: 15) {
          Text("Main Goal")
            .font(.title3)
            .fontWeight(.bold)
          Text("Sharpen your ability to understand unspoken cues and implied meanings in conversations and situations.")
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
        }
        
        Divider()
        
        // MARK: - How it works
        
        VStack(alignment: .center, spacing: 15) {
          Text("How it works ?")
            .font(.title3)
            .fontWeight(.bold)
          Text("This lesson presents you with various real-world scenarios, from short dialogues to brief descriptions of events. Your task is to analyze the provided information and then select the most appropriate underlying context from a set of choices. Each correct answer helps you fine-tune your intuition and develop a deeper understanding of social dynamics.")
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        
        Spacer()
        
        // MARK: - Start Button
        
        Button {
          // viewModel.startLesson()
        } label: {
          Label("Start the lesson", systemImage: "play.circle.fill")
            .padding(12)
        }
        .prominentButtonStyle(tint: .pink)
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
  GuessTheContextSetupView()
}

//
//  GenerateButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 29.07.2025.
//

import SwiftUI

extension GuessTheContextView {
  
  struct GenerateButton: View {
    @Environment(GuessTheContextViewModel.self) var viewModel
    
    var body: some View {
      Button {
        withAnimation {
          viewModel.startNewLesson()
        }
      } label: {
        Label("Generate", systemImage: "sparkles")
          .font(.headline)
          .padding(13)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
  
}

#Preview {
  GuessTheContextView.GenerateButton()
    .environment(GuessTheContextViewModel.previewMode)
}

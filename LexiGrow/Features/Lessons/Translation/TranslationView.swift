//
//  TranslationView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.08.2025.
//

import SwiftUI

struct TranslationView: View {
  @Bindable var viewModel: TranslationViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      if viewModel.currentSentence != nil {
        Text("Перекладіть речення:")
          .font(.headline)
        
        Text(viewModel.sourceText)
          .font(.title2)
          .fontWeight(.semibold)
          .multilineTextAlignment(.center)
          .padding()
          .frame(maxWidth: .infinity)
          .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        
        TextField("Ваш переклад...", text: $viewModel.userInput, axis: .vertical)
          .padding()
          .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(borderColor, lineWidth: 2)
          )
        
        Button("Перевірити") {
          viewModel.checkAnswer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(viewModel.answerState == .idle ? .blue : .gray)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(viewModel.answerState != .idle)
      } else {
        ProgressView()
      }
    }
    .padding()
    .navigationTitle("Переклад речень")
  }
  
  var borderColor: Color {
    switch viewModel.answerState {
    case .idle:
      return .gray.opacity(0.3)
    case .correct:
      return .green
    case .incorrect:
      return .red
    }
  }
}

#Preview {
  TranslationView(viewModel: TranslationViewModel(supabaseService: SupabaseService.mockObject))
  .environment(TranslationViewModel.mockObject)
}

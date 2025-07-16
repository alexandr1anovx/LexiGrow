//
//  GuessTheContextView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.07.2025.
//

import SwiftUI
import GoogleGenerativeAI

struct GuessTheContextView: View {
  @State private var generatedText: String = "This is where the text will be displayed."
  @State private var isLoading: Bool = false
  @State private var isShowingExitSheet: Bool = false
  @Environment(\.dismiss) var dismiss
  
  private let model = GenerativeModel(
    name: "gemini-1.5-flash",
    apiKey: "AIzaSyAvp16KVd9zRoKbyBPHtRYgkNDxSZZRR6Q"
  )
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        ScrollView {
          Text(generatedText)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(
              Capsule()
                .fill(Color.gradientBluePurple.secondary)
            )
        }.shadow(radius: 10)
        
        Button(action: generateContext) {
          if isLoading {
            ProgressView()
              .progressViewStyle(.circular)
          } else {
            Label("Generate Text", systemImage: "sparkles")
          }
        }
        .linearGradientButtonStyle(bgColor: Color.gradientBluePurple)
        .shadow(radius: 10)
        .disabled(isLoading)
      }
      .padding()
      .navigationTitle("Guess the context")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isShowingExitSheet = true
          } label: {
            Image(systemName: "xmark.circle.fill")
              .font(.title)
              .symbolRenderingMode(.hierarchical)
              .foregroundStyle(.red)
          }
        }
      }
      .sheet(isPresented: $isShowingExitSheet) {
        ExitLessonView {
          dismiss()
        }
      }
    }
  }
  
  // MARK: - Subviews
  
  func generateContext() {
    isLoading = true
    generatedText = ""
    Task {
      do {
        let prompt = ""
        let response = try await model.generateContent(prompt)
        if let text = response.text {
          generatedText = text
        }
      } catch {
        generatedText = "Error happened: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
}

#Preview {
  GuessTheContextView()
}

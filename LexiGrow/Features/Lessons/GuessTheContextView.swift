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
  @State private var isShownExitSheet: Bool = false
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
            .foregroundStyle(.white)
            .fontWeight(.medium)
            .padding()
            .frame(
              maxWidth: .infinity,
              minHeight: 80,
              alignment: .center
            )
            .background(
              LinearGradient(
                colors: [.blue, .orange],
                startPoint: .leading,
                endPoint: .trailing
              ).opacity(0.6)
            )
            .cornerRadius(15)
        }
        .shadow(radius: 15)
        
        Button(action: generateContext) {
          if isLoading {
            ProgressView()
              .progressViewStyle(.circular)
          } else {
            Label("Generate Text", systemImage: "sparkles")
          }
        }
        .linearGradientButtonStyle()
        .shadow(radius:10)
        .disabled(isLoading)
      }
      .padding()
      .navigationTitle("Guess the context")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isShownExitSheet = true
          } label: {
            Image(systemName: "xmark.circle.fill")
              .font(.title)
              .symbolRenderingMode(.hierarchical)
              .foregroundStyle(.red)
          }
        }
      }
      .sheet(isPresented: $isShownExitSheet) {
        exitPreview
      }
    }
  }
  
  private var exitPreview: some View {
    VStack(spacing: 15) {
      Spacer()
      Text("Finish the lesson?")
        .font(.title2)
        .fontWeight(.semibold)
      Text("Are you sure you want to exit the lesson?")
        .font(.callout)
        .fontWeight(.medium)
        .foregroundStyle(.gray)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      Spacer()
      HStack {
        Button {
          // action
        } label: {
          Text("Cancel")
            .standardButtonStyle(bgColor: .gray)
        }
        Button {
          dismiss()
        } label: {
          Text("Finish")
            .standardButtonStyle(bgColor: .red)
        }
      }.padding(.bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
  }
  
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
        generatedText = "Error happened:: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
}

#Preview {
  GuessTheContextView()
}

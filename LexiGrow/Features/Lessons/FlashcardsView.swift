//
//  FlashcardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FlashcardsView: View {
  @State private var isShownExitSheet: Bool = true
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Flashcards View")
          .font(.title2)
          .fontWeight(.bold)
      }
      .padding()
      .navigationTitle("Flashcards")
      .navigationBarTitleDisplayMode(.large)
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
        .font(.title)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
      Text("All progress will be canceled.")
        .font(.callout)
        .fontWeight(.medium)
        .foregroundStyle(.white.opacity(0.8))
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      Spacer()
      HStack {
        Button {
          isShownExitSheet = false
        } label: {
          Text("Cancel")
            .padding(11)
            .foregroundStyle(.white)
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(.bordered)
        Button {
          dismiss()
        } label: {
          Text("Finish")
            .padding(11)
            .foregroundStyle(.red)
            .fontWeight(.medium)
        }
        .tint(.white)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
      }.padding(.bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationBackground(
      LinearGradient(
        colors: [.red.opacity(0.8), .pink.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
      )
    )
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
  }
}

#Preview {
  FlashcardsView()
}

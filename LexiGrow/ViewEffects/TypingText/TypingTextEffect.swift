//
//  TypingEffectView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct TypingTextEffect: View {
  
  let text: String
  @State private var displayedText = ""
  @State private var isDeleting = false
  @State private var timer: Timer?
  @State private var typingTextOpacity = 0.0
  
  var body: some View {
    HStack(spacing: 0) {
      Text(displayedText)
        .font(.subheadline)
        .fontWeight(.semibold)
        .underline()
        .fontDesign(.monospaced)
      Rectangle() // Cursor
        .frame(width: 2, height: 20)
    }
    .onAppear {
      startAnimation()
    }
    .onDisappear {
      timer?.invalidate()
    }
    .foregroundStyle(displayedText == text ? .primary : .secondary)
    .opacity(typingTextOpacity)
  }
  
  private func startAnimation() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { _ in
      if isDeleting {
        if !displayedText.isEmpty {
          displayedText.removeLast()
          typingTextOpacity -= 0.1
        } else {
          isDeleting = false
        }
      } else {
        if displayedText.count < text.count {
          let index = text.index(text.startIndex, offsetBy: displayedText.count)
          displayedText.append(text[index])
          typingTextOpacity += 0.1
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isDeleting = true
          }
        }
      }
    }
  }
}

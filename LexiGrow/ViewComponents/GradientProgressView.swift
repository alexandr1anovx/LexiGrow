//
//  GradientRingProgressView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 29.07.2025.
//

import SwiftUI

struct GradientProgressView: View {
  @State private var isAnimating = false
  var tint: Color? // blue by default
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(.gray.tertiary, lineWidth: 5)
      Circle()
        .trim(from: 0, to: 0.3)
        .stroke(
          tint ?? .blue,
          style: StrokeStyle(lineWidth: 5, lineCap: .round)
        )
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
        .onAppear {
          isAnimating = true
        }
    }
    .frame(width: 20, height: 20)
    .shadow(radius: 3)
  }
}

#Preview {
  GradientProgressView()
}

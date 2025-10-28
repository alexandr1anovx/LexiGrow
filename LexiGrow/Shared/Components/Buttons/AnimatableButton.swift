//
//  AnimatableButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 28.10.2025.
//

import SwiftUI

struct AnimatableButton: View {
  let title: String
  var textColor: Color
  var tint: Color
  var action: () -> Void
  
  @State private var isAnimating = false
  
  init(
    _ title: String,
    textColor: Color = .white,
    tint: Color = .mainGreen,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.textColor = textColor
    self.tint = tint
    self.action = action
  }
  
  var body: some View {
    ZStack {
      Capsule(style: .continuous)
        .fill(AngularGradient(colors: [.yellow, .mainGreen, .orange], center: .center, angle: .degrees(isAnimating ? 360 : 0)))
        .frame(height: 45)
        .blur(radius: 13)
        .onAppear {
          withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            isAnimating = true
          }
        }
      
      if #available(iOS 26, *) {
        Button(action: action) {
          Text(title)
            .fontWeight(.medium)
            .foregroundStyle(textColor)
            .padding(9)
            .frame(maxWidth: .infinity)
        }
        .tint(tint)
        .buttonStyle(.glassProminent)
      } else {
        Button(action: action) {
          Text(title)
            .fontWeight(.medium)
            .foregroundStyle(textColor)
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(tint)
            .clipShape(.capsule)
        }
      }
    }
  }
}

#Preview {
  AnimatableButton("Get Started", tint: .mainGreen) {}
}

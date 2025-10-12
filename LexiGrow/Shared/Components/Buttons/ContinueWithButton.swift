//
//  ContinueWithButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.10.2025.
//

import SwiftUI

/// Кнопка для авторизації через провайдера (наприклад, Google або Apple).
struct ContinueWithButton: View {
  let provider: String
  let iconName: String
  let action: () -> Void
  
  init(
    _ provider: String,
    iconName: String,
    action: @escaping () -> Void
  ) {
    self.provider = provider
    self.iconName = iconName
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 12) {
        Image(iconName)
          .resizable()
          .frame(width: 20, height: 20)
        Text("Continue with \(provider)")
          .fontWeight(.medium)
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color(.systemGray6), in: Capsule())
      .foregroundColor(.primary)
    }
    .padding(.horizontal, .horizontalPadding)
  }
}

#Preview {
  ContinueWithButton("Google", iconName: "googleIcon") {}
}

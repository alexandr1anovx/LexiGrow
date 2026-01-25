//
//  PrimaryButton.swift
//  ReWord
//
//  Created by Alexander Andrianov on 22.09.2025.
//

import SwiftUI

struct PrimaryButton: View {
  let title: String
  var textColor: Color
  var tint: Color
  var action: () -> Void
  
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

#Preview {
  PrimaryButton("Save changes") {}
}

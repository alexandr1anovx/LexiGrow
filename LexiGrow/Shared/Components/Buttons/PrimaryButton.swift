//
//  PrimaryButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.09.2025.
//

import SwiftUI

/// Button style for iOS < 26.
struct PrimaryButton: View {
  let title: String
  var textColor: Color = .white
  var tint: Color = .blue
  var withPadding: Bool = true
  var action: () -> Void
  
  var body: some View {
    Group {
      if #available(iOS 26, *) {
        Button(action: action) {
          Text(title)
            .fontWeight(.medium)
            .foregroundStyle(textColor)
            .padding(10)
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
    }.padding(.horizontal, withPadding ? 15:0)
  }
}

#Preview {
  PrimaryButton(title: "Save changes", tint: .green, withPadding: true) {}
  PrimaryButton(title: "Edit profile", tint: .blue, withPadding: true) {}
}

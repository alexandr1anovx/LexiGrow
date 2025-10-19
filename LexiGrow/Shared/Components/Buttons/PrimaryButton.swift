//
//  PrimaryButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.09.2025.
//

import SwiftUI

struct PrimaryButton: View {
  let title: String
  var textColor: Color = .white
  var tint: Color = .blue
  var action: () -> Void
  
  var body: some View {
    Group {
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
  PrimaryButton(title: "Save changes", tint: .green) {}
  PrimaryButton(title: "Edit profile", tint: .blue) {}
}

struct IconButton: View {
  let iconName: String
  var tint: Color = .blue
  var action: () -> Void
  
  var body: some View {
    Group {
      if #available(iOS 26, *) {
        Button(action: action) {
          Image(systemName: iconName)
        }
        .tint(tint)
        .buttonStyle(.glassProminent)
      } else {
        Button(action: action) {
          Image(systemName: iconName)
            .fontWeight(.medium)
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(tint)
            .clipShape(.capsule)
        }
      }
    }
  }
}

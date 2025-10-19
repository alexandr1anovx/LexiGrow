//
//  View+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

extension View {
  
  func prominentLabelStyle(tint: Color) -> some View {
    self
      .fontWeight(.medium)
      .foregroundStyle(.white)
      .padding(15)
      .frame(maxWidth: .infinity)
      .background(tint)
      .clipShape(.capsule)
  }
  
  func modernLabelStyle(textColor: Color = .primary) -> some View {
    self
      .fontWeight(.medium)
      .padding(11)
      .frame(maxWidth: .infinity)
      .foregroundStyle(textColor)
  }
  
  func capsuleLabelStyle(
    pouring: Color = Color(.systemGray6)
  ) -> some View {
    self
      .font(.callout)
      .fontWeight(.medium)
      .padding(15)
      .background {
        Capsule().fill(pouring)
      }
  }
}

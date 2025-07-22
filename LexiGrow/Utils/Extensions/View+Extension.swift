//
//  View+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

extension View {
  
  // MARK: - Button Styles
  
  func prominentButtonStyle(
    tint: Color,
    textColor: Color? = nil
  ) -> some View {
    self
      .font(.callout)
      .fontWeight(.medium)
      .foregroundStyle(textColor ?? .white)
      .tint(tint)
      .buttonBorderShape(
        .roundedRectangle(radius: 20)
      )
      .buttonStyle(.borderedProminent)
      .shadow(radius: 3)
  }
  
  func borderedButtonStyle(
    tint: Color,
    textColor: Color? = nil
  ) -> some View {
    self
      .font(.callout)
      .fontWeight(.medium)
      .foregroundStyle(textColor ?? .white)
      .tint(tint)
      .buttonBorderShape(
        .roundedRectangle(radius: 20)
      )
      .buttonStyle(.bordered)
      .shadow(radius: 3)
  }
  
  // MARK: - Input Field Style
  
  func inputFieldStyle() -> some View {
    self
      .font(.subheadline)
      .padding()
      .frame(minHeight:55)
      .overlay {
        RoundedRectangle(cornerRadius:15)
          .stroke(.secondary.tertiary, lineWidth: 1)
      }
  }
}


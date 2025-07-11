//
//  View+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

extension View {
  func standardButtonStyle(bgColor: Color) -> some View {
    self
      .font(.callout)
      .fontWeight(.medium)
      .fontDesign(.monospaced)
      .foregroundStyle(.white)
      .padding(.vertical,16)
      .padding(.horizontal,35)
      .background(bgColor)
      .clipShape(.capsule)
      .shadow(radius: 5)
  }
  
  func gradientButtonStyle(
    bgColor: LinearGradient? = Color.gradientOrangePink
  ) -> some View {
    self
      .font(.callout)
      .fontWeight(.medium)
      .fontDesign(.monospaced)
      .foregroundStyle(.white)
      .padding(.vertical,16)
      .padding(.horizontal,35)
      .background(bgColor)
      .clipShape(.capsule)
      .shadow(radius: 5)
  }
  
  func customInputFieldStyle() -> some View {
    self
      .font(.subheadline)
      .fontDesign(.monospaced)
      .padding()
      .frame(minHeight: 55)
      .overlay {
        RoundedRectangle(cornerRadius: 20)
          .stroke(.secondary.tertiary, lineWidth: 1)
      }
  }
}

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
      .foregroundStyle(.white)
      .padding(.vertical,17)
      .padding(.horizontal,35)
      .background(bgColor)
      .clipShape(.capsule)
      .shadow(radius:5)
  }
  
  func gradientButtonStyle(bgColor: AnyGradient) -> some View {
    self
      .font(.callout)
      .fontWeight(.semibold)
      .foregroundStyle(.white)
      .padding(.vertical,17)
      .padding(.horizontal,35)
      .background(bgColor.secondary)
      .clipShape(.capsule)
      .shadow(radius:5)
  }
  
  func linearGradientButtonStyle(
    bgColor: LinearGradient? = Color.gradientOrangePink
  ) -> some View {
    self
      .font(.headline)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .padding(.vertical,17)
      .background(bgColor)
      .clipShape(.rect(cornerRadius: 17))
  }
  
  func customInputFieldStyle() -> some View {
    self
      .font(.subheadline)
      .padding()
      .frame(minHeight:55)
      .overlay {
        RoundedRectangle(cornerRadius:15)
          .stroke(.secondary.tertiary, lineWidth:1)
      }
  }
}


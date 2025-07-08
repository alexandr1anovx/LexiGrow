//
//  View+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

extension View {
  func customInputFieldStyle() -> some View {
    self
      .padding()
      .frame(minHeight: 55)
      .overlay {
        RoundedRectangle(cornerRadius: 15)
          .inset(by: 0.5)
          .stroke(.gray.opacity(0.5), lineWidth: 1)
      }
  }
}

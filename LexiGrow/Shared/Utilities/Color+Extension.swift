//
//  Color+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.10.2025.
//

import SwiftUI

extension Color {
  static let system = Color(.systemBackground)
  static let systemGray = Color(.systemGray6)
  
  static let flashcard = LinearGradient(
    colors: [.olive, .blue], startPoint: .topLeading, endPoint: .bottomTrailing
  )
}

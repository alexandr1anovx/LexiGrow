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
  
  // MARK: - Gradients
  
  static let yellowGreenGradient = LinearGradient(
    colors: [.mainYellow, .mainGreen],
    startPoint: .leading,
    endPoint: .trailing
  )
  static let whiteGradient = LinearGradient(
    colors: [.white],
    startPoint: .leading,
    endPoint: .trailing
  )
  static let onboardingLastPageBackground = LinearGradient(
    colors: [.mainYellow, .mainGreen],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

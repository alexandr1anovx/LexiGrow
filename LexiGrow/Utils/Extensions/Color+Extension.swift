//
//  Color+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 11.07.2025.
//

import SwiftUI

extension Color {
  static var gradientOrangePink = LinearGradient(
    colors: [.orange.opacity(0.8), .pink.opacity(0.5)],
    startPoint: .leading,
    endPoint: .trailing
  )
  static var gradientBlue = LinearGradient(
    colors: [.blue],
    startPoint: .leading,
    endPoint: .trailing
  )
  static var gradientIndigo = LinearGradient(
    colors: [.indigo],
    startPoint: .leading,
    endPoint: .trailing
  )
  static var gradientPurple = LinearGradient(
    colors: [.purple],
    startPoint: .leading,
    endPoint: .trailing
  )
}

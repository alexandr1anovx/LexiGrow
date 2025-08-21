//
//  ThemeChangerView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 10.08.2025.
//

import SwiftUI

enum Theme: String, Identifiable, CaseIterable {
  case system = "System"
  case light = "Light"
  case dark = "Dark"
  
  var id: Self { self }
  var colorScheme: ColorScheme? {
    switch self {
    case .system: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}

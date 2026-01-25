//
//  ThemeChangerView.swift
//  ReWord
//
//  Created by Alexander Andrianov on 10.08.2025.
//

import SwiftUI

enum AppTheme: String, Identifiable, CaseIterable {
  case system, light, dark
  
  var id: Self { self }
  var title: String {
    switch self {
    case .system: "Системна"
    case .light: "Світла"
    case .dark: "Темна"
    }
  }
  var colorScheme: ColorScheme? {
    switch self {
    case .system: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}

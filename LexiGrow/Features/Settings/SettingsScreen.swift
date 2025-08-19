//
//  SettingsScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 10.08.2025.
//

import SwiftUI

struct SettingsScreen: View {
  @AppStorage("user_theme") private var userTheme: Theme = .system
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  @State private var isExpanded = true
  
  var body: some View {
    Form {
      Section("Appearance") {
        DisclosureGroup("Color Scheme", isExpanded: $isExpanded) {
          HStack(spacing: 15) {
            ForEach(Theme.allCases) { theme in
              Text(theme.rawValue)
                .frame(minWidth: 60)
                .foregroundStyle(userTheme == theme ? Color(.systemBackground) : Color.primary)
                .padding(10)
                .background(userTheme == theme ? Color.primary : Color.clear)
                .clipShape(.rect(cornerRadius: 20))
                .onTapGesture {
                  userTheme = theme
                  feedbackGenerator.impactOccurred()
                }
            }
          }
        }
      }
    }
  }
}

#Preview {
  SettingsScreen()
}

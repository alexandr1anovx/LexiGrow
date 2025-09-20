//
//  SettingsScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 10.08.2025.
//

import SwiftUI

struct SettingsScreen: View {
  @AppStorage("app_scheme") private var appScheme: Theme = .system
  @State private var isExpandedSchemePanel = true
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    Form {
      Section("Appearance") {
        DisclosureGroup("Color Scheme", isExpanded: $isExpandedSchemePanel) {
          HStack(spacing: 15) {
            ForEach(Theme.allCases) { theme in
              Button {
                appScheme = theme
                feedbackGenerator.impactOccurred()
              } label: {
                Text(theme.rawValue)
                  .frame(minWidth: 60)
                  .foregroundStyle(appScheme == theme ? Color(.systemBackground) : Color.primary)
                  .padding(10)
                  .background(appScheme == theme ? Color.primary : Color.clear)
                  .clipShape(.rect(cornerRadius: 20))
              }
            }
          }
        }
      }
      NavigationLink {
        PreferencesView()
      } label: {
        Text("Preferences")
      }
    }
  }
}
#Preview {
  NavigationView {
    SettingsScreen()
  }
}

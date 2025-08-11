//
//  SettingsScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 10.08.2025.
//

import SwiftUI

struct SettingsScreen: View {
  @AppStorage("user_theme") private var userTheme: Theme = .system
  
  var body: some View {
    Form {
      Section("Appearance") {
        DisclosureGroup("Color Scheme") {
          HStack(spacing: 15) {
            ForEach(Theme.allCases) { theme in
              Text(theme.rawValue)
                .frame(minWidth: 60)
                .foregroundStyle(userTheme == theme ? Color(.systemBackground) : Color.primary)
                .padding(11)
                .background(userTheme == theme ? Color.primary : Color.clear)
                .clipShape(.rect(cornerRadius: 20))
                .onTapGesture { userTheme = theme }
                .animation(.snappy, value: userTheme)
            }
          }
        }
      }
      Section("Other Settings") {
        
      }
    }
  }
}

#Preview {
  SettingsScreen()
}

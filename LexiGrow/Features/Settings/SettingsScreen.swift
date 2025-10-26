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
    ZStack {
      Color.mainBackground.ignoresSafeArea()
      Form {
        Section("Appearance") {
          DisclosureGroup("Color Scheme", isExpanded: $isExpandedSchemePanel) {
            HStack {
              ForEach(Theme.allCases) { theme in
                Text(theme.rawValue)
                  .foregroundStyle(appScheme == theme ? Color(.systemBackground) : Color.primary)
                  .padding(10)
                  .background(appScheme == theme ? Color.primary : Color.clear)
                  .clipShape(.rect(cornerRadius: 20))
                  .onTapGesture {
                    appScheme = theme
                    feedbackGenerator.impactOccurred()
                  }
                Spacer()
              }
            }.padding(.horizontal)
          }
        }
        NavigationLink {
          UserPreferencesScreen()
        } label: {
          Text("Preferences")
        }
      }.scrollContentBackground(.hidden)
    }
  }
}
#Preview {
  NavigationView {
    SettingsScreen()
  }
}

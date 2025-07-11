//
//  AppTabView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

enum Tab {
  case home, profile
}

struct LaunchView: View {
  @Environment(AuthManager.self) private var authManager
  
  var body: some View {
    Group {
      if authManager.currentUser != nil {
        AppTabView()
      } else {
        LoginScreen(authManager: authManager)
      }
    }
    .task {
      await authManager.refreshUser()
    }
  }
}

struct AppTabView: View {
  @Environment(AuthManager.self) private var authManager
  @State private var selectedTab: Tab = .home
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    TabView(selection: $selectedTab) {
      HomeScreen()
        .tag(Tab.home)
        .tabItem {
          Label("Home", systemImage: "house")
        }
      GeneralScreen(authManager: authManager)
        .tag(Tab.profile)
        .tabItem {
          Label("Profile", systemImage: "person")
        }
    }
    .onChange(of: selectedTab) { // Creates a haptic feedback when selecting a tab.
      feedbackGenerator.impactOccurred()
    }
  }
}

#Preview {
  AppTabView()
    .environment(AuthManager())
}

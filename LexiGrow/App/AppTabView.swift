//
//  AppTabView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

enum Tab {
  case lessons, general
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
  @State private var selectedTab: Tab = .lessons
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    TabView(selection: $selectedTab) {
      LessonsTabScreen()
        .tag(Tab.lessons)
        .tabItem {
          Label("Lessons", systemImage: "book.pages")
        }
      GeneralTabScreen(authManager: authManager)
        .tag(Tab.general)
        .tabItem {
          Label("General", systemImage: "ellipsis.circle.fill")
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
    .environment(FlashcardsViewModel())
}

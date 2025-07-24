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



struct AppTabView: View {
  @Environment(AuthManager.self) private var authManager
  @State private var selectedTab: Tab = .lessons
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  @State private var flashcardViewModel = FlashcardsViewModel()
  @State private var guessTheContextViewModel = GuessTheContextViewModel()
  
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
    .environment(flashcardViewModel)
    .environment(guessTheContextViewModel)
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

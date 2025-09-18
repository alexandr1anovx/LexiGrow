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

struct MainTabView: View {
  @State private var selectedTab: Tab = .lessons
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    TabView(selection: $selectedTab) {
      LessonsScreen()
        .tag(Tab.lessons)
        .tabItem {
          Label("Lessons", systemImage: "book.pages")
        }
      MoreScreen()
        .tag(Tab.general)
        .tabItem {
          Label("More", systemImage: "water.waves")
        }
    }
    .onChange(of: selectedTab) {
      feedbackGenerator.impactOccurred()
    }
  }
}

#Preview {
  MainTabView()
    .environment(AuthManager.mockObject)
    .environment(FlashcardViewModel.mockObject)
    .environment(StatisticsViewModel.mockObject)
    .environment(LessonsViewModel.mockObject)
    .environment(SupabaseService.mockObject)
}

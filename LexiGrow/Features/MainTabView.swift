//
//  AppTabView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

enum Tab {
  case lessons, more
}

struct MainTabView: View {
  @State private var selectedTab: Tab = .lessons
  
  var body: some View {
    TabView(selection: $selectedTab) {
      LessonsScreen()
        .tabItem { Label("Уроки", systemImage: "book.closed") }
        .tag(Tab.lessons)
      MoreScreen()
        .tabItem { Label("Інше", systemImage: "water.waves") }
        .tag(Tab.more)
    }
  }
}

#Preview {
  MainTabView()
    .environment(AuthManager.mock)
    .environment(CardsViewModel.mock)
    .environment(LessonProgressViewModel.mock)
    .environment(LessonsViewModel.mock)
    .environment(EducationService.mock)
}

//
//  AppTabView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

enum Tab: String {
  case lessons = "Уроки"
  case more = "Інше"
  
  var iconName: String {
    switch self {
    case .lessons: "book.closed"
    case .more: "water.waves"
    }
  }
}

struct MainTabView: View {
  @State private var selectedTab: Tab = .lessons
  
  var body: some View {
    TabView(selection: $selectedTab) {
      LessonsScreen()
        .tabItem { Label(Tab.lessons.rawValue, systemImage: Tab.lessons.iconName) }
        .tag(Tab.lessons)
      MoreScreen()
        .tabItem { Label(Tab.more.rawValue, systemImage: Tab.more.iconName) }
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

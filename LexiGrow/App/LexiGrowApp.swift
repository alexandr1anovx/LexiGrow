//
//  LexiGrowApp.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 20.06.2025.
//

import SwiftUI
import SwiftData

@main
struct LexiGrowApp: App {
  
  @AppStorage("user_theme") private var userTheme: Theme = .system
  private let supabaseService = SupabaseService()
  private let authManager = AuthManager()
  @State private var lessonsViewModel: LessonsViewModel
  @State private var statisticsViewModel: StatisticsViewModel
  @State private var flashcardViewModel: FlashcardViewModel
  @State private var translationViewModel: TranslationViewModel
  
  init() {
    self._lessonsViewModel = State(wrappedValue: LessonsViewModel(supabaseService: supabaseService))
    self._statisticsViewModel = State(wrappedValue: StatisticsViewModel(supabaseService: supabaseService))
    self._flashcardViewModel = State(wrappedValue: FlashcardViewModel(supabaseService: supabaseService))
    self._translationViewModel = State(wrappedValue: TranslationViewModel(supabaseService: supabaseService))
  }
  
  var body: some Scene {
    WindowGroup {
      Group {
        switch authManager.authState {
        case .unauthenticated:
          LoginScreen()
        case .waitingForEmailConfirmation:
          EmailConfirmationScreen()
        case .authenticated:
          MainTabView()
        }
      }
      .preferredColorScheme(userTheme.colorScheme)
      .environment(supabaseService)
      .environment(authManager)
      .environment(lessonsViewModel)
      .environment(statisticsViewModel)
      .environment(flashcardViewModel)
      .environment(translationViewModel)
      .task {
        await authManager.refreshUser()
      }
    }
    // SwiftData model container
    // (the same as the PersistentController in CoreData)
    .modelContainer(for: [LessonEntity.self, LevelProgress.self])
  }
}

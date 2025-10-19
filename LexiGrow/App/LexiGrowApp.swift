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
  
  @AppStorage("app_scheme") private var appScheme: Theme = .system
  private let supabaseService = SupabaseService()
  private let authManager = AuthManager()
  
  @State private var lessonsViewModel: LessonsViewModel
  @State private var statisticsViewModel: StatisticsViewModel
  @State private var flashcardViewModel: FlashcardViewModel
  @State private var translationViewModel: TranslationViewModel
  
  @State private var showLaunchView = true
  
  init() {
    self._lessonsViewModel = State(wrappedValue: LessonsViewModel(supabaseService: supabaseService))
    self._statisticsViewModel = State(wrappedValue: StatisticsViewModel(supabaseService: supabaseService))
    self._flashcardViewModel = State(wrappedValue: FlashcardViewModel(supabaseService: supabaseService))
    self._translationViewModel = State(wrappedValue: TranslationViewModel(supabaseService: supabaseService))
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        if showLaunchView {
          LaunchView()
        } else {
          Group {
            switch authManager.authState {
            case .unauthenticated:
              LoginScreen()
            case .waitingForEmailConfirmation:
              EmailConfirmationView()
            case .authenticated:
              MainTabView()
            }
          }
        }
      }
      .animation(.spring, value: showLaunchView)
      .animation(.spring, value: authManager.authState)
      .preferredColorScheme(appScheme.colorScheme)
      .environment(supabaseService)
      .environment(authManager)
      .environment(lessonsViewModel)
      .environment(statisticsViewModel)
      .environment(flashcardViewModel)
      .environment(translationViewModel)
      .modelContainer(for: [LessonEntity.self, LevelProgress.self])
      
      // Handles the redirect back to the app after Google Sign In.
      .onOpenURL { url in
        Task {
          do {
            try await SupabaseManager.shared.client.auth.session(from: url)
          } catch {
            print("Error handling deep link: \(error.localizedDescription)")
          }
        }
      }
      // Observes auth state changes.
      .task {
        for await (event, _) in SupabaseManager.shared.client.auth.authStateChanges {
          if event == .signedIn || event == .userUpdated || event == .tokenRefreshed {
            await authManager.refreshUser()
          }
        }
      }
      // Delays content display for 1.5 seconds to load data.
      .onAppear {
        Task {
          try? await Task.sleep(for: .seconds(1.5))
          showLaunchView = false
        }
      }
    }
  }
}

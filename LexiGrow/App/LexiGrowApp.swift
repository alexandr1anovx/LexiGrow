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
  @AppStorage("isCompleteOnboarding") private var isCompleteOnboarding = false
  @State private var showLaunchScreen = true
  
  // MARK: - View Models
  
  @State private var lessonsViewModel: LessonsViewModel
  @State private var lessonProgressViewModel: LessonProgressViewModel
  @State private var cardsViewModel: CardsViewModel
  @State private var translationViewModel: TranslationViewModel
  
  // MARK: - Services & Managers
  
  private let authManager = AuthManager()
  private let educationService = EducationService()
  
  init() {
    self._lessonsViewModel = State(wrappedValue: LessonsViewModel(educationService: educationService))
    self._lessonProgressViewModel = State(wrappedValue: LessonProgressViewModel(educationService: educationService))
    self._cardsViewModel = State(wrappedValue: CardsViewModel(educationService: educationService))
    self._translationViewModel = State(wrappedValue: TranslationViewModel(educationService: educationService))
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        if showLaunchScreen {
          LaunchScreen()
        } else {
          if isCompleteOnboarding {
            switch authManager.authState {
            case .unauthenticated:
              LoginScreen(authManager: authManager)
            case .waitingForEmailConfirmation:
              EmailConfirmationView(email: authManager.currentUser!.email)
            case .authenticated:
              MainTabView()
            }
          } else {
            OnboardingScreen(onComplete: { isCompleteOnboarding = true })
          }
        }
      }
      .animation(.easeInOut, value: showLaunchScreen)
      .animation(.easeInOut, value: authManager.authState)
      .animation(.easeInOut, value: isCompleteOnboarding)
      .preferredColorScheme(appScheme.colorScheme)
      .environment(educationService)
      .environment(authManager)
      .environment(lessonsViewModel)
      .environment(lessonProgressViewModel)
      .environment(cardsViewModel)
      .environment(translationViewModel)
      .modelContainer(for: [LessonEntity.self, LevelProgressEntity.self])
      
      // Handles the redirect back to the app after Google Sign In.
      .onOpenURL { url in
        Task {
          do {
            try await SupabaseService.shared.client.auth.session(from: url)
          } catch {
            print("Error handling deep link: \(error.localizedDescription)")
          }
        }
      }
      // Observes auth state changes.
      .task {
        for await (event, _) in SupabaseService.shared.client.auth.authStateChanges {
          if event == .signedIn || event == .userUpdated || event == .tokenRefreshed {
            await authManager.refreshUser()
          }
        }
      }
      // Delays content display for 1.5 seconds.
      .onAppear {
        Task {
          try? await Task.sleep(for: .seconds(1.5))
          showLaunchScreen = false
        }
      }
    }
  }
}

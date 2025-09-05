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
      .task {
        await lessonsViewModel.getLessons()
      }
    }
    // a model container for the LevelProgress (the same as the PersistentController in core data).
    .modelContainer(for: LevelProgress.self)
  }
}

struct EmailConfirmationScreen: View {
  @Environment(AuthManager.self) var authManager
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  var body: some View {
    VStack(spacing: 30) {
      VStack(spacing: 20) {
        Image(systemName: "envelope.badge")
          .font(.system(size: 40))
          .foregroundStyle(.primary)
        Text("Confirm your email")
          .font(.title)
          .fontWeight(.semibold)
        Text("We have sent a confirmation link to your email address. Please check your inbox.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
      
      VStack(spacing: 15) {
        // Resend Button
        Button {
          alertTitle = "Letter sent"
          alertMessage = "We have resent the confirmation letter to your email address."
          showAlert = true
        } label: {
          Text("Resend")
            .prominentButtonStyle(tint: .pink)
        }
        // Refresh Button
        Button {
          Task { await authManager.refreshUser() }
        } label: {
          Label("Refresh", systemImage: "arrow.clockwise.circle")
            .foregroundStyle(.accent)
            .prominentButtonStyle(tint: Color(.systemGray5))
        }
      }
      Spacer()
    }
    .padding()
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text(alertTitle),
        message: Text(alertMessage),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}

#Preview {
  EmailConfirmationScreen()
    .environment(AuthManager.mockObject)
}

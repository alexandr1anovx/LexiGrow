//
//  LexiGrowApp.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 20.06.2025.
//

import SwiftUI

@main
struct LexiGrowApp: App {
  @State private var authManager = AuthManager()
  @State private var flashcardViewModel = FlashcardsViewModel()
  @State private var guessTheContextViewModel = GuessTheContextViewModel()
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(authManager)
        .environment(flashcardViewModel)
        .environment(guessTheContextViewModel)
    }
  }
}

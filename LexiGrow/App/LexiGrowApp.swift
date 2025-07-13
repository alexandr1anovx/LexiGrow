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
  
  var body: some Scene {
    WindowGroup {
      LaunchView()
        .environment(authManager)
    }
  }
}

//
//  LaunchView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct LaunchView: View {
  @Environment(AuthManager.self) private var authManager
  
  var body: some View {
    Group {
      if authManager.currentUser != nil {
        AppTabView()
      } else {
        LoginScreen(authManager: authManager)
      }
    }
    .task {
      await authManager.refreshUser()
    }
  }
}

//
//  RootView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 29.07.2025.
//

import SwiftUI

struct RootView: View {
  @Environment(AuthManager.self) private var authManager
  @State private var isLoadingLaunchView: Bool = true
  
  var body: some View {
    Group {
      if authManager.currentUser != nil {
        if isLoadingLaunchView {
          LaunchView()
        } else {
          AppTabView()
        }
      } else {
        LoginScreen(authManager: authManager)
      }
    }
    .task {
      await authManager.refreshUser()
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        isLoadingLaunchView = false
      }
    }
  }
}

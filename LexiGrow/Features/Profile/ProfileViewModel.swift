//
//  ProfileViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import Foundation

@Observable
@MainActor
final class ProfileViewModel {
  
  // MARK: - Published Properties
  
  var username: String = ""
  var email: String = ""
  var isShownSignOutSheet: Bool = false
  var isShownLanguageSheet: Bool = false
  
  // MARK: - Computed Properties
  
  var formHasChanges: Bool {
    guard let user = authManager.currentUser else { return false }
    let changedUsername = username != user.username
    let changedEmail = email != user.email
    return changedUsername || changedEmail
  }
  
  // MARK: - Dependencies
  
  private let authManager: AuthManager
  
  // MARK: - Init / Deinit
  
  init(authManager: AuthManager) {
    self.authManager = authManager
    print("✅ Profile View Model has been initialized.")
    Task { await getUserData() }
  }
  deinit {
    print("❌ Profile View Model has been deinitialized.")
  }
  
  // MARK: - Public Methods
  
  func updateUser() {
    Task {
      await authManager.updateUser(username: username)
    }
  }
  
  func signOut() {
    Task {
      await authManager.signOut()
    }
  }
  
  func getUserData() async {
    guard let user = authManager.currentUser else { return }
    username = user.username
    email = user.email
  }
}

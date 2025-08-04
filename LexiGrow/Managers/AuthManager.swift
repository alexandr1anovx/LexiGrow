//
//  AppSessionManager.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

@MainActor
@Observable
final class AuthManager {
  var currentUser: AppUser?
  var isLoading: Bool = false
  private let authService: AuthService
  
  init(authService: AuthService = AuthService()) {
    self.authService = authService
    print("✅ Auth Manager initialized.")
  }
  deinit {
    print("❌ Auth Manager deinitialized.")
  }
  
  func signIn(email: String, password: String) async {
    isLoading = true
    do {
      self.currentUser = try await authService.signIn(
        email: email,
        password: password
      )
    } catch {
      print("⚠️ AuthManager: Failed to sign in: \(error.localizedDescription)")
    }
    isLoading = false
  }
  
  func signUp(username: String, email: String, password: String) async {
    isLoading = true
    do {
      self.currentUser = try await authService.signUp(
        username: username,
        email: email,
        password: password
      )
    } catch {
      print("⚠️ AuthManager: Failed to sign up: \(error.localizedDescription)")
    }
    isLoading = false
  }
  
  func signOut() async {
    isLoading = true
    do {
      try await authService.signOut()
      currentUser = nil
    } catch {
      print("⚠️ AuthManager: Failed to sign out: \(error.localizedDescription)")
    }
    isLoading = false
  }
  
  func updateUser(username: String) async {
    guard currentUser != nil else { return }
    isLoading = true
    do {
      let updatedUser = try await authService.updateUser(username: username)
      self.currentUser = updatedUser
    } catch {
      print("⚠️ AuthManager: Failed to update user: \(error.localizedDescription)")
    }
    isLoading = false
  }
  
  func refreshUser() async {
    do {
      self.currentUser = try await authService.getCurrentUser()
    } catch {
      print("⚠️ Refresh current user error: \(error.localizedDescription)")
      currentUser = nil
    }
  }
}

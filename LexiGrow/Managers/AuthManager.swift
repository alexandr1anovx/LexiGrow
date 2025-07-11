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
  private let authService: AuthServiceProtocol
  
  init(authService: AuthServiceProtocol = AuthService()) {
    self.authService = authService
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
  
  func refreshUser() async {
    do {
      self.currentUser = try await authService.getCurrentUser()
    } catch {
      print("Refresh current user error: \(error)")
      currentUser = nil
    }
  }
}

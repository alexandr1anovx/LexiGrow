//
//  AppSessionManager.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

@Observable final class AuthManager {
  var currentUser: AppUser?
  private(set) var signInError: String?
  private(set) var signUpError: String?
  private(set) var signOutError: String?
  private(set) var updateProfileError: String?
  private(set) var isLoading = false
  private let authService: AuthService
  
  init(authService: AuthService = AuthService()) {
    self.authService = authService
  }
  
  func signIn(email: String, password: String) async {
    isLoading = true
    defer { isLoading = false }
    do {
      self.currentUser = try await authService.signIn(
        email: email,
        password: password
      )
    } catch {
      signInError = "Failed to sign in: \(error)"
    }
  }
  
  func signUp(username: String, email: String, password: String) async {
    isLoading = true
    defer { isLoading = false }
    do {
      self.currentUser = try await authService.signUp(
        username: username,
        email: email,
        password: password
      )
    } catch {
      signUpError = "Failed to sign up: \(error)"
    }
  }
  
  func signOut() async {
    isLoading = true
    do {
      try await authService.signOut()
      currentUser = nil
    } catch {
      signOutError = "Failed to sign out: \(error)"
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
      updateProfileError = "Failed to update user: \(error)"
    }
    isLoading = false
  }
  
  func refreshUser() async {
    do {
      self.currentUser = try await authService.getCurrentUser()
    } catch {
      currentUser = nil
    }
  }
}

extension AuthManager {
  static let mock = AuthManager()
}

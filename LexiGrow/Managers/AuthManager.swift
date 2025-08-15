//
//  AppSessionManager.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

@Observable final class AuthManager {
  var currentUser: AppUser?
  private(set) var error: AuthError?
  private(set) var isLoading = false
  private let authService: AuthService
  
  init(authService: AuthService = AuthService()) {
    self.authService = authService
  }
  
  func signIn(email: String, password: String) async {
    resetState()
    defer { isLoading = false }
    
    do {
      self.currentUser = try await authService.signIn(
        email: email,
        password: password
      )
    } catch {
      self.error = error as? AuthError ?? .unknown
    }
  }
  
  func signUp(username: String, email: String, password: String) async {
    resetState()
    defer { isLoading = false }
    
    do {
      self.currentUser = try await authService.signUp(
        username: username,
        email: email,
        password: password
      )
    } catch {
      self.error = error as? AuthError ?? .unknown
    }
  }
  
  func signOut() async {
    resetState()
    defer { isLoading = false }
    
    do {
      try await authService.signOut()
      currentUser = nil
    } catch {
      self.error = error as? AuthError ?? .unknown
    }
  }
  
  func updateUser(username: String) async {
    guard currentUser != nil else { return }
    resetState()
    defer { isLoading = false }
    
    do {
      let updatedUser = try await authService.updateUser(username: username)
      self.currentUser = updatedUser
    } catch {
      self.error = error as? AuthError ?? .unknown
    }
  }
  
  func refreshUser() async {
    do {
      self.currentUser = try await authService.getCurrentUser()
    } catch {
      currentUser = nil
      self.error = error as? AuthError ?? .userNotFound
    }
  }
  
  // Method for resetting errors from the UI.
  func clearError() {
    self.error = nil
  }
  
  private func resetState() {
    isLoading = true
    error = nil
  }
}

extension AuthManager {
  static let mockObject = AuthManager()
}

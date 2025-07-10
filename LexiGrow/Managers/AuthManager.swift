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
  var currentUser: User?
  private let authService: SupabaseAuthService
  
  var isLoading: Bool = false
  
  init(authService: SupabaseAuthService = SupabaseAuthService()) {
    self.authService = authService
  }
  
  func signIn(email: String, password: String) async {
    isLoading = false
    do {
      isLoading = true
      self.currentUser = try await authService.signIn(email: email, password: password)
      isLoading = false
    } catch {
      isLoading = false
      print("DEBUG: Sign in error: \(error.localizedDescription)")
    }
  }
  
  func signUp(email: String, password: String) async {
    isLoading = false
    do {
      isLoading = true
      self.currentUser = try await authService.signUp(email: email, password: password)
      isLoading = false
    } catch {
      isLoading = false
      print("DEBUG: Sign up error: \(error.localizedDescription)")
    }
  }
  
  func signOut() async {
    do {
      try await authService.signOut()
      currentUser = nil
    } catch {
      print("DEBUG: Sign out error: \(error.localizedDescription)")
    }
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

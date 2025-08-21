//
//  AppSessionManager.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

enum AuthState {
  case unauthenticated
  case waitingForEmailConfirmation
  case authenticated
}

@Observable final class AuthManager {
  var currentUser: AppUser?
  private(set) var authState: AuthState = .unauthenticated
  private(set) var error: AuthError?
  private(set) var isLoading = false
  
  private let authService: AuthService
  
  init(authService: AuthService = AuthService()) {
    self.authService = authService
  }
  
  func requestPasswordReset(for email: String) {
    Task {
      do {
        try await authService.requestPasswordReset(for: email)
      } catch {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func signIn(email: String, password: String) async {
    resetState()
    defer { isLoading = false }
    
    do {
      /*
      self.currentUser = try await authService.signIn(
        email: email,
        password: password
      )
      */
      let user = try await authService.signIn(
        email: email,
        password: password
      )
      self.authState = user.emailConfirmed ? .authenticated : .waitingForEmailConfirmation
      self.currentUser = user
      
    } catch {
      self.error = error as? AuthError ?? .unknown
      self.authState = .unauthenticated
    }
  }
  
  func signUp(username: String, email: String, password: String) async {
    resetState()
    defer { isLoading = false }
    
    do {
      let user = try await authService.signUp(
        username: username,
        email: email,
        password: password
      )
      if user.emailConfirmed == false {
        self.authState = .waitingForEmailConfirmation
        self.currentUser = user
      } else {
        self.authState = .authenticated
        self.currentUser = user
      }
    } catch {
      self.error = error as? AuthError ?? .unknown
    }
  }
  
  func signOut() async {
    isLoading = true
    do {
      try await authService.signOut()
      authState = .unauthenticated
      isLoading = false
      currentUser = nil
    } catch {
      self.error = error as? AuthError ?? .unknown
      isLoading = false
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
  
//  func refreshUser() async {
//    isLoading = true
//    defer { isLoading = false }
//    do {
//      self.currentUser = try await authService.getCurrentUser()
//    } catch {
//      currentUser = nil
//      self.error = error as? AuthError ?? .userNotFound
//    }
//  }
  
  func refreshUser() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let user = try await authService.getCurrentUser()
      self.currentUser = user
      self.authState = user.emailConfirmed ? .authenticated : .waitingForEmailConfirmation
    } catch {
      currentUser = nil
      self.error = error as? AuthError ?? .userNotFound
      self.authState = .unauthenticated
    }
  }
  
  private func resetState() {
    isLoading = true
    error = nil
  }
}

extension AuthManager {
  static let mockObject = AuthManager()
}

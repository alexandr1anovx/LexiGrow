//
//  AppSessionManager.swift
//  ReWord
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

enum AuthState {
  case unauthenticated
  case waitingForEmailConfirmation
  case authenticated
}

@Observable
@MainActor
final class AuthManager {
  
  // MARK: - Published Properties
  var authError: AuthError?
  private(set) var authState: AuthState = .unauthenticated
  private(set) var currentUser: AppUser?
  private(set) var isLoading = false
  
  private let authService: AuthServiceProtocol
  
  init(authService: AuthServiceProtocol = AuthService()) {
    self.authService = authService
    
    Task { await refreshUser() }
  }
  
  // MARK: - Public methods
  
  /// Authenticates a user using email and password.
  func signIn(email: String, password: String) async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      let user = try await authService.signIn(email: email, password: password)
      updateUserState(with: user)
    } catch {
      handle(error: error)
    }
  }
  
  /// Registers a new user with full name, email, and password.
  func signUp(fullName: String, email: String, password: String) async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      let user = try await authService.signUp(fullName: fullName, email: email, password: password)
      if user.emailConfirmed == false {
        self.authState = .waitingForEmailConfirmation
        self.currentUser = user
      } else {
        self.authState = .authenticated
        self.currentUser = user
      }
    } catch {
      handle(error: error)
    }
  }
  
  /// Signs out the current user.
  func signOut() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try await authService.signOut()
      self.currentUser = nil
      self.authState = .unauthenticated
    } catch {
      handle(error: error)
    }
  }
  
  /// Asynchronously updates the full name of the currently authenticated user.
  func updateUser(fullName: String) async {
    guard currentUser != nil else { return }
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      let updatedUser = try await authService.updateUser(fullName: fullName)
      self.currentUser = updatedUser
    } catch {
      handle(error: error)
    }
  }
  
  /// Sends a password reset request to the specified email address.
  func requestPasswordReset(for email: String) async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      try await authService.requestPasswordReset(for: email)
    } catch {
      handle(error: error)
    }
  }
  
  /// Refreshes the current user's data from the server.
  func refreshUser() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let user = try await authService.getCurrentUser()
      updateUserState(with: user)
      self.authError = nil
    } catch {
      self.currentUser = nil
      //handle(error: error)
    }
  }
  
  /// Deletes the current user's account.
  /*
  func deleteUser() async {
    guard currentUser != nil else { return }
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      try await authService.deleteUser()
      self.currentUser = nil
      self.authState = .unauthenticated
    } catch {
      handle(error: error)
    }
  }
  */
  
  func fetchConnectedProviders() async -> [String] {
    do {
      return try await authService.getConnectedProviders()
    } catch {
      print("Failed to get providers list: \(error)")
      return ["No Providers Used"]
    }
  }
  
  // MARK: - Sign In Providers
  
  /// Initiates the sign-in flow via Google.
  func signInWithGoogle() async {
    do {
      guard let bundleId = Bundle.main.bundleIdentifier else { return }
      try await authService.signInWithGoogle(bundleId: bundleId)
    } catch {
      handle(error: error)
    }
  }
  
  func signInWithMagicLink(for email: String) async {
    do {
      try await authService.signInWithMagicLink(for: email)
    } catch {
      print("Failed to sign in with magic link: \(error)")
    }
  }
  
  // MARK: - Private methods
  
  /// Prepares the manager's state for a new asynchronous request.
  private func prepareForRequest() {
    isLoading = true
    authError = nil
  }
  
  /// Updates the user and authentication state based on the provided AppUser object.
  private func updateUserState(with user: AppUser) {
    self.currentUser = user
    self.authState = user.emailConfirmed ? .authenticated : .authenticated
  }
  
  /// Handles errors and updates the state for UI presentation.
  private func handle(error: Error) {
    if let specificAuthError = error as? AuthError {
      self.authError = specificAuthError
    } else {
      self.authError = .unknown(description: error.localizedDescription)
    }
    self.authState = .unauthenticated
  }
  
  func sendOTP(for phoneNumber: String) async -> Bool {
    isLoading = true
    authError = nil
    defer { isLoading = false }
    
    do {
      try await authService.sendOTP(for: phoneNumber)
      print("OTP successfully sent to \(phoneNumber)")
      return true
    } catch {
      print("AuthManager Error (sendOTP): \(error.localizedDescription)")
      return false
    }
  }
  
  func verifyOTP(for phoneNumber: String, with code: String) async {
    isLoading = true
    authError = nil
    defer { isLoading = false }
    
    do {
      try await authService.verifyOTP(for: phoneNumber, with: code)
      print("Phone number verified successfully. User is logged in.")
      self.authState = .authenticated
    } catch {
      print("AuthManager Error (verifyOTP): \(error.localizedDescription)")
    }
  }
}

// MARK: - Mock Object

extension AuthManager {
  static var mock: AuthManager = {
    let manager = AuthManager()
    manager.currentUser = .mockUser
    manager.authState = .authenticated
    manager.authError = nil
    manager.isLoading = false
    return manager
  }()
}

//
//  SupabaseAuthService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import Supabase

protocol AuthServiceProtocol {
  func signIn(email: String, password: String) async throws -> AppUser
  func signInWithGoogle(bundleId: String) async throws
  func signInWithMagicLink(for email: String) async throws
  
  func signUp(fullName: String, email: String, password: String) async throws -> AppUser
  func signOut() async throws
  func updateUser(fullName: String) async throws -> AppUser
  func getCurrentUser() async throws -> AppUser
  func requestPasswordReset(for email: String) async throws
  
  func getConnectedProviders() async throws -> [String]
  
  func sendOTP(for phoneNumber: String) async throws
  func verifyOTP(for phoneNumber: String, with code: String) async throws
}

class AuthService: AuthServiceProtocol {
  
  /// Authenticates a user using email and password.
  func signIn(email: String, password: String) async throws -> AppUser {
    do {
      let session = try await SupabaseService.shared.client.auth.signIn(email: email, password: password)
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.invalidCredentials
    }
  }
  
  /// Registers a new user with full name, email, and password.
  func signUp(fullName: String, email: String, password: String) async throws -> AppUser {
    do {
      let session = try await SupabaseService.shared.client.auth.signUp(
        email: email,
        password: password,
        data: ["fullName": .string(fullName)]
      )
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.serverError
    }
  }
  
  /// Signs out the current user.
  func signOut() async throws {
    do {
      try await SupabaseService.shared.client.auth.signOut()
    } catch {
      throw AuthError.serverError
    }
  }
  
  /// Asynchronously updates the full name of the currently authenticated user.
  func updateUser(fullName: String) async throws -> AppUser {
    let updatedUser = try await SupabaseService.shared.client.auth.update(
      user: UserAttributes(data: ["fullName": .string(fullName)])
    )
    return try mapSupabaseUserToAppUser(updatedUser)
  }
  
  /// Sends a password reset request to the specified email address.
  func requestPasswordReset(for email: String) async throws {
    try await SupabaseService.shared.client.auth.resetPasswordForEmail(email)
  }
  
  /// Retrieves the current authenticated session and maps it to the `AppUser` model.
  func getCurrentUser() async throws -> AppUser {
    do {
      let session = try await SupabaseService.shared.client.auth.session
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.unknown(description: error.localizedDescription)
    }
  }
  
  // MARK: - Sign In Providers
  
  /// Authenticates a user via Google account.
  ///
  /// This method initiates the OAuth sign-in flow with Google.
  /// During sign-in, the user is always prompted to choose a Google account.
  ///
  /// - Parameter bundleId: The app’s bundle identifier, used to form the callback URL.
  func signInWithGoogle(bundleId: String) async throws {
    try await SupabaseService.shared.client.auth.signInWithOAuth(
      provider: .google,
      redirectTo: URL(string: "\(bundleId)://"),
      // always prompts the user to select a Google account.
      queryParams: [(name: "prompt", value: "select_account")]
    )
  }
  
  /// Sends a magic link for sign-in to the specified email address.
  ///
  /// The method generates a one-time link for passwordless sign-in.
  /// After following the link, the user will be redirected back into the app.
  ///
  /// - Parameter email: The user's email address to send the magic link to.
  func signInWithMagicLink(for email: String) async throws {
    try await SupabaseService.shared.client.auth.signInWithOTP(
      email: email,
      redirectTo: URL(string: "lexigrow://callback")
    )
  }
  
  // MARK: - Private methods
  
  /// Maps a Supabase user to the internal `AppUser` model by extracting core fields and user metadata.
  private func mapSupabaseUserToAppUser( _ supabaseUser: Supabase.User) throws -> AppUser {
    guard let email = supabaseUser.email else {
      throw AuthError.invalidCredentials
    }
    
    let fullName: String
    let metadata = supabaseUser.userMetadata
    
    if let nameValue = metadata["fullName"], case .string(let fullname) = nameValue {
      fullName = fullname
    } else {
      fullName = "Full Name Not Provided"
      //fullName = email.components(separatedBy: "@").first ?? "User"
    }
    
    return AppUser(
      id: supabaseUser.id,
      fullName: fullName,
      email: email,
      emailConfirmed: supabaseUser.emailConfirmedAt != nil
    )
  }
  
  func getConnectedProviders() async throws -> [String] {
    let user = try await SupabaseService.shared.client.auth.user()
    guard let providerNames = user.identities?.compactMap({ $0.provider }) else {
      return []
    }
    return providerNames
  }
  
  func sendOTP(for phoneNumber: String) async throws {
    try await SupabaseService.shared.client.auth.signInWithOTP(phone: phoneNumber)
  }
  
  func verifyOTP(for phoneNumber: String, with code: String) async throws {
    try await SupabaseService.shared.client.auth.verifyOTP(
      phone: phoneNumber,
      token: code,
      type: .sms
    )
  }
}

// MARK: - Auth Error


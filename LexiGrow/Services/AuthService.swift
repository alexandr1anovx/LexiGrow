//
//  SupabaseAuthService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import Supabase

struct AuthService {
  
  // MARK: - Public methods
  
  func signIn(email: String, password: String) async throws -> AppUser {
    do {
      let session = try await supabase.auth.signIn(
        email: email,
        password: password
      )
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.invalidCredentials(description: error.localizedDescription)
    }
  }
  
  func signUp(username: String, email: String, password: String) async throws -> AppUser {
    do {
      let session = try await supabase.auth.signUp(
        email: email,
        password: password,
        data: ["username": .string(username)]
      )
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.serverError(description: error.localizedDescription)
    }
  }
  
  func signOut() async throws {
    do {
      try await supabase.auth.signOut()
    } catch {
      throw AuthError.serverError(description: error.localizedDescription)
    }
  }
  
  func updateUser(username: String) async throws -> AppUser {
    let updatedUser = try await supabase.auth.update(
      user: UserAttributes(data: ["username": .string(username)])
    )
    return try mapSupabaseUserToAppUser(updatedUser)
  }
  
  func getCurrentUser() async throws -> AppUser {
    do {
      let session = try await supabase.auth.session
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.userNotFound
    }
  }
  
  // MARK: - Private methods
  
  private func mapSupabaseUserToAppUser(
    _ supabaseUser: Supabase.User
  ) throws -> AppUser {
    
    guard let email = supabaseUser.email else {
      throw AuthError.invalidEmail
    }
    let username: String
    let metadata = supabaseUser.userMetadata
    if let nameValue = metadata["username"],
       case .string(let usrname) = nameValue {
      username = usrname
    } else {
      username = "No username"
    }
    return AppUser(
      id: supabaseUser.id,
      username: username,
      email: email
    )
  }
}

// MARK: - Auth Error

enum AuthError: Error, LocalizedError {
    case userNotFound
    case invalidEmail
    case invalidCredentials(description: String)
    case serverError(description: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found."
        case .invalidEmail:
            return "Invalid email format."
        case .invalidCredentials(let description):
            return "Invalid credentials: \(description)"
        case .serverError(let description):
            return "Server error: \(description)"
        case .unknown:
            return "An unknown error occured."
        }
    }
}

//
//  SupabaseAuthService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import Supabase

protocol AuthServiceProtocol {
  
  func signIn(
    email: String,
    password: String
  ) async throws -> AppUser
  
  func signUp(
    username: String,
    email: String,
    password: String
  ) async throws -> AppUser
  
  func signOut() async throws
  func getCurrentUser() async throws -> AppUser
}

struct AuthService: AuthServiceProtocol {
  private let client: SupabaseClient
  
  init() {
    self.client = SupabaseClient(
      supabaseURL: URL(string: Constants.projectURLString)!,
      supabaseKey: Constants.projectAPIKey
    )
  }
  
  // MARK: - Public Methods
  
  func signIn(email: String, password: String) async throws -> AppUser {
    do {
      let session = try await client.auth.signIn(
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
      let session = try await client.auth.signUp(
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
      try await client.auth.signOut()
    } catch {
      throw AuthError.serverError(description: error.localizedDescription)
    }
  }
  
  func getCurrentUser() async throws -> AppUser {
    do {
      let session = try await client.auth.session
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.userNotFound
    }
  }
  
  // MARK: - Private Methods
  
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
      id: supabaseUser.id.uuidString,
      username: username,
      email: email
    )
  }
}

enum AuthError: Error {
  case userNotFound
  case invalidEmail
  case invalidCredentials(description: String)
  case serverError(description: String)
  case unknown
  
  var localizedDescription: String {
    switch self {
    case .userNotFound: 
      return "User Not Found"
    case .invalidEmail:
      return "Invalid Email"
    case .invalidCredentials(let description):
      return "Invalid Credentials: \(description)"
    case .serverError(let description):
      return "Server Error: \(description)"
    case .unknown:
      return "Unkown Error"
    }
  }
}

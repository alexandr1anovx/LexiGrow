//
//  SupabaseAuthService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import Supabase

struct SupabaseAuthService {
  private let supabaseClient: SupabaseClient
  
  init() {
    self.supabaseClient = SupabaseClient(
      supabaseURL: URL(string: Constants.projectURLString)!,
      supabaseKey: Constants.projectAPIKey
    )
  }
  
  func signIn(email: String, password: String) async throws -> User {
    let response = try await supabaseClient.auth.signIn(email: email, password: password)
    print(response.user)
    guard let email = response.user.email else {
      print("DEBUG: No email")
      throw NSError() // create own error handling
    }
    return User(id: response.user.aud, email: email)
  }
  
  func signUp(email: String, password: String) async throws -> User {
    let response = try await supabaseClient.auth.signUp(email: email, password: password)
    print(response.user)
    guard let email = response.user.email else {
      print("DEBUG: No email")
      throw NSError() // create own error handling
    }
    return User(id: response.user.aud, email: email)
  }
  
  func signOut() async throws {
    try await supabaseClient.auth.signOut()
  }
  
  func getCurrentUser() async throws -> User? {
    let supabaseUser = try await supabaseClient.auth.session.user
    guard let email = supabaseUser.email else {
      print("DEBUG: No email")
      throw NSError()
    }
    return User(id: supabaseUser.aud, email: email)
  }
}

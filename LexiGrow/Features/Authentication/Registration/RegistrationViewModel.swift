//
//  RegistrationViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import SwiftUICore

@Observable
@MainActor
final class RegistrationViewModel {
  
  // MARK: - Published Properties
  var username: String = ""
  var email: String = ""
  var password: String = ""
  var confirmedPassword: String = ""
  
  // MARK: - Computed Properties
  var isValidForm: Bool {
    !username.isEmpty
    && !email.isEmpty
    && !password.isEmpty && password == confirmedPassword
  }
  
  // MARK: - Private Properties
  private let authManager: AuthManager
  
  // MARK: - Init / Deinit
  init(authManager: AuthManager) {
    self.authManager = authManager
    print("✅ Registration View Model has been initialized.")
  }
  deinit {
    print("❌ Registration View Model has been deinitialized.")
  }
  
  // MARK: - Public Methods
  func signUp() {
    Task {
      await authManager.signUp(
        username: username,
        email: email,
        password: password
      )
    }
  }
}

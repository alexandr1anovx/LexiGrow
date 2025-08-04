//
//  LoginViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import SwiftUICore

@Observable
@MainActor
final class LoginViewModel {
  
  // MARK: - Public Properties
  var email: String = ""
  var password: String = ""
  
  // MARK: - Private Properties
  private let authManager: AuthManager
  
  // MARK: - Computed Properties
  var isValidForm: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  // MARK: - Init / Deinit
  init(authManager: AuthManager) {
    self.authManager = authManager
    print("✅ Login View Model has been initialized.")
  }
  deinit {
    print("❌ Login View Model has been deinitialized.")
  }
  
  // MARK: - Public Methods
  func signIn() {
    Task {
      await authManager.signIn(email: email, password: password)
    }
  }
}

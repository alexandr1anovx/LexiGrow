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
  
  var email: String = ""
  var password: String = ""
  
  var isValidForm: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  private let authManager: AuthManager
  
  init(authManager: AuthManager) {
    self.authManager = authManager
  }
  
  func signIn() {
    Task {
      await authManager.signIn(email: email, password: password)
    }
  }
}

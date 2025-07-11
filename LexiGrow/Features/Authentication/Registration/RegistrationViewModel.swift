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
  var username: String = ""
  var email: String = ""
  var password: String = ""
  var confirmedPassword: String = ""
  
  var isValidForm: Bool {
    !username.isEmpty
    && !email.isEmpty
    && !password.isEmpty && password == confirmedPassword
  }
  
  private let authManager: AuthManager
  
  init(authManager: AuthManager) {
    self.authManager = authManager
  }
  
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

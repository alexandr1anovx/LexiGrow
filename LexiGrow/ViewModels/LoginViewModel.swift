//
//  LoginViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation

@Observable class LoginViewModel {
  var email: String = ""
  var password: String = ""
  
  var isValidForm: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  func signIn() {}
}

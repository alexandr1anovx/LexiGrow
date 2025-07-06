//
//  RegistrationViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation

@Observable class RegistrationViewModel {
  var fullName: String = ""
  var email: String = ""
  var password: String = ""
  var confirmedPassword: String = ""
  
  var isValidForm: Bool {
    !fullName.isEmpty
    && !email.isEmpty
    && !password.isEmpty && password == confirmedPassword
  }
  
  func signUp() {}
}

//
//  TextFieldContent.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import Foundation

enum Field {
  
  // MARK: Cases
  
  case fullName
  case email
  case password
  case confirmPassword
  case phoneNumber
  
  // MARK: Title
  
  var title: String {
    switch self {
    case .fullName: "Full name"
    case .email: "Email address"
    case .password: "Password"
    case .confirmPassword: "Confirm password"
    case .phoneNumber: "+380(50) 123 45 67"
    }
  }
  
  // MARK: Icon Name
  
  var iconName: String {
    switch self {
    case .fullName: "person.fill"
    case .email: "at"
    case .password: "lock.fill"
    case .confirmPassword: "lock.fill"
    case .phoneNumber: "phone.fill"
    }
  }
}

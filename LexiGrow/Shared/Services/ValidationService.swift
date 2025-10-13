//
//  ValidationService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.09.2025.
//

import Foundation

protocol ValidationServiceProtocol {
  func isValidFullName(_ fullName: String) -> Bool
  func isValidUsername(_ username: String) -> Bool
  func isValidEmail(_ email: String) -> Bool
  func isValidPassword(_ password: String) -> Bool
  func isValidUkrainianPhoneNumber(_ phoneNumber: String) -> Bool
}

final class ValidationService: ValidationServiceProtocol {
  
  static let shared = ValidationService()
  private init() {}
  
  func isValidFullName(_ fullName: String) -> Bool {
    let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmed.count >= 2 && trimmed.count <= 50 else { return false }
    let pattern = "^[A-Za-zА-Яа-яЁёІіЇїЄє'’\\-\\s]+$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
    return predicate.evaluate(with: trimmed)
  }
  
  func isValidUsername(_ username: String) -> Bool {
    let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmed.count >= 3 && trimmed.count <= 20 else { return false }
    let pattern = "^[A-Za-z0-9_-]+$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
    return predicate.evaluate(with: trimmed)
  }
  
  func isValidEmail(_ email: String) -> Bool {
    let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
    return predicate.evaluate(with: trimmed)
  }
  
  func isValidPassword(_ password: String) -> Bool {
    password.count >= 6
  }
  
  func isValidUkrainianPhoneNumber(_ phoneNumber: String) -> Bool {
    let phoneRegex = #"^(\+?38|8)?0\s?\(?\d{2}\)?\s?\d{3}-?\d{2}-?\d{2}$"#
    let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phonePredicate.evaluate(with: phoneNumber)
  }
  
}

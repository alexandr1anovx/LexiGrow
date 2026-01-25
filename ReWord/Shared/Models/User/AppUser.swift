//
//  User.swift
//  ReWord
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

struct AppUser: Codable, Identifiable, Equatable {
  let id: UUID
  var fullName: String
  var email: String
  let emailConfirmed: Bool
  
  var firstName: String {
    fullName.components(separatedBy: " ").first ?? fullName
  }
  var lastName: String {
    fullName.components(separatedBy: " ").last ?? fullName
  }
}

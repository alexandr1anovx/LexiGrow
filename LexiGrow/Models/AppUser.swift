//
//  User.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

struct AppUser: Codable, Identifiable, Equatable {
  let id: String
  var username: String
  var email: String
}

extension AppUser {
  static var mockUser: AppUser {
    AppUser(id: "1", username: "Alex", email: "address@mail.com")
  }
}

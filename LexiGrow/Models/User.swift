//
//  User.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

struct User: Codable, Identifiable {
  let id: String
  var name: String
  var surname: String
  var email: String
  var username: String?
  var joinDate: Date
  
  var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: joinDate)
  }
}

extension User {
  static var mockUser: User {
    User(
      id: "1",
      name: "Alex",
      surname: "Andrianov",
      email: "alex@gmail.com",
      username: "alexandr1anov",
      joinDate: Date.now
    )
  }
}

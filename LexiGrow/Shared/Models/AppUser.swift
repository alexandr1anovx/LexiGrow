//
//  User.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

struct AppUser: Codable, Identifiable, Equatable {
  let id: UUID
  var username: String
  var email: String
  let emailConfirmed: Bool
}

struct UserProgress: Codable {
  let userId: UUID
  let wordId: UUID
  let learnedAt: Date
  
  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case wordId = "word_id"
    case learnedAt = "learned_at"
  }
}

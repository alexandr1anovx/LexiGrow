//
//  UserProgress.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.08.2025.
//

import Foundation

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

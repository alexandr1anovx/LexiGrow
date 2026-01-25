//
//  UserProgress.swift
//  ReWord
//
//  Created by Oleksandr Andrianov on 01.12.2025.
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

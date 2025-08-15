//
//  Level.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 05.08.2025.
//

import Foundation

struct Level: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let orderIndex: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case orderIndex = "order_index"
  }
}

struct LevelProgress: Identifiable {
  let id: UUID
  let name: String
  let orderIndex: Int
  let totalWords: Int
  let learnedWords: Int
  
  var progress: Double {
    guard totalWords > 0 else { return 0.0 }
    return Double(learnedWords) / Double(totalWords)
  }
}

extension Level {
  static let mock = Level(
    id: UUID(),
    name: "B1.1",
    orderIndex: 1
  )
}

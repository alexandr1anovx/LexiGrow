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
  static let mockB1 = Level(id: UUID(), name: "B1", orderIndex: 1)
  static let mockB2 = Level(id: UUID(), name: "B2", orderIndex: 2)
}

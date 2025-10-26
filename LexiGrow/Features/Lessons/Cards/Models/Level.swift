//
//  Level.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 05.08.2025.
//

import Foundation
import SwiftData

struct Level: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let orderIndex: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case orderIndex = "order_index"
  }
}

@Model
final class LevelProgressEntity {
  @Attribute(.unique)
  var id: UUID
  var name: String
  var orderIndex: Int
  var totalWords: Int
  var learnedWords: Int
  
  var progress: Double {
    guard totalWords > 0 else { return 0.0 }
    return Double(learnedWords) / Double(totalWords)
  }
  
  init(id: UUID, name: String, orderIndex: Int, totalWords: Int, learnedWords: Int) {
    self.id = id
    self.name = name
    self.orderIndex = orderIndex
    self.totalWords = totalWords
    self.learnedWords = learnedWords
  }
}

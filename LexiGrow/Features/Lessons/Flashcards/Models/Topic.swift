//
//  Topic.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 05.08.2025.
//

import Foundation

struct Topic: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
}

/// A model that matches the result of RPC function 'get_level_progress'
struct TopicProgress: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let totalWords: Int
  let learnedWords: Int
  
  /// Used to sort topics
  var progress: Double {
    guard totalWords > 0 else { return 0.0 }
    return Double(learnedWords) / Double(totalWords)
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "topic_id"
    case name = "topic_name"
    case totalWords = "total_words"
    case learnedWords = "learned_words"
  }
}

extension Topic {
  static let mockAppearance = Topic(id: UUID(), name: "Appearance")
}

extension TopicProgress {
  static let mock1 = TopicProgress(id: UUID(), name: "Daily Life", totalWords: 20, learnedWords: 0)
  static let mock2 = TopicProgress(id: UUID(), name: "Eating", totalWords: 20, learnedWords: 10)
  static let mock3 = TopicProgress(id: UUID(), name: "Appearance", totalWords: 20, learnedWords: 20)
}

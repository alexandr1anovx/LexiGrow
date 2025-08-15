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

/// A model that matches the result of RPC function 'get_level_progress'.
struct TopicProgress: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let totalWords: Int
  let learnedWords: Int
  
  enum CodingKeys: String, CodingKey {
    case id = "topic_id"
    case name = "topic_name"
    case totalWords = "total_words"
    case learnedWords = "learned_words"
  }
}

extension Topic {
  static let mock = Topic(id: UUID(), name: "Appearance")
}

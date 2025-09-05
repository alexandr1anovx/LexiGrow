//
//  Topic.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 05.08.2025.
//

import Foundation

/// A model that matches the result of RPC function 'get_topic_progress'
struct Topic: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let totalWords: Int
  let learnedWords: Int
  
  /// Topic progress. Used for sorting options.
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

enum TopicSortOption: String, CaseIterable, Identifiable {
  case defaultOrder = "Default"
  case uncompletedFirst = "Uncompleted first"
  case completedFirst = "Completed first"
  case alphabeticalAZ = "Alphabetical (A-Z)"
  
  var id: Self { self }
  
  var iconName: String {
    switch self {
    case .defaultOrder: return "list.bullet"
    case .uncompletedFirst: return "xmark.circle.fill"
    case .completedFirst: return "checkmark.circle.fill"
    case .alphabeticalAZ: return "textformat.abc"
    }
  }
}

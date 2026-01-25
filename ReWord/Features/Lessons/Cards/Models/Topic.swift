//
//  Topic.swift
//  ReWord
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
    return Double(learnedWords / totalWords)
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "topic_id"
    case name = "topic_name"
    case totalWords = "total_words"
    case learnedWords = "learned_words"
  }
}

enum TopicSortOption: String, CaseIterable, Identifiable {
  case defaultOrder = "За замовчуванням"
  case alphabetical = "За алфавітом"
  case completedFirst = "Спочатку завершені"
  case uncompletedFirst = "Спочатку незавершені"
  case minimumWords = "Найменше слів"
  case maximumWords = "Найбільше слів"
  
  var id: Self { self }
  
  var iconName: String {
    switch self {
    case .defaultOrder: "list.bullet"
    case .uncompletedFirst: "xmark.circle.fill"
    case .completedFirst: "checkmark.circle.fill"
    case .alphabetical: "textformat.abc"
    case .minimumWords: "lessthan"
    case .maximumWords: "greaterthan"
    }
  }
}

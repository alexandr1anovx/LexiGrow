//
//  WordProvider.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation

struct WordProvider {
  
  private static let dictionary: [Word] = Bundle.main.decode(
    [Word].self,
    from: "words.json"
  )
  
  // Output example: ["cabbage", "lettuce" ...] (for level "B1.1" and topic "Eating")
  static func getWords(for level: String, topic: String) -> [Word] {
    return dictionary.filter {
      $0.level == level &&
      $0.topic == topic
    }
    .shuffled()
  }
  
  
  static func getTopics(for level: String) -> [String] {
    let topics = dictionary
      .filter { $0.level == level }
      .map { $0.topic }
    return Array(Set(topics)).sorted()
  }
}

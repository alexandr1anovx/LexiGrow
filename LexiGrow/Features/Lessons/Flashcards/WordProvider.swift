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
  static func getRandomWords(count: Int) -> [Word] {
    let requestedCount = min(count, dictionary.count)
    return Array(dictionary.shuffled().prefix(requestedCount))
  }
}

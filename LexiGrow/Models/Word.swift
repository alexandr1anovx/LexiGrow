//
//  Word.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation

struct Word: Identifiable, Hashable, Codable {
  let id: String
  let original: String
  let translation: String
  let level: String
  let topic: String
}

extension Word {
  static var mock: Word {
    Word(
      id: "01",
      original: "Bus",
      translation: "Автобус",
      level: "B1.1",
      topic: "Vehicles"
    )
  }
}

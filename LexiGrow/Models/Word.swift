//
//  Word.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation

struct Word: Identifiable, Hashable, Codable {
  let id: UUID = UUID()
  let original: String
  let translation: String
  
  enum CodingKeys: String, CodingKey {
    case original = "word"
    case translation
  }
}

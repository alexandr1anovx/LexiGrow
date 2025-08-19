//
//  Sentence.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.08.2025.
//

import Foundation

struct Sentence: Codable, Identifiable, Hashable {
  let id: UUID
  let englishSentence: String
  let ukrainianSentence: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case englishSentence = "english_sentence"
    case ukrainianSentence = "ukrainian_sentence"
  }
}

//
//  Flashcard.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import Foundation

struct Flashcard: Identifiable {
  let id: String
  var word: Word
  var status: Status = .unknown
  
  enum Status {
    case unknown
    case known
    case needsRepetition
  }
}

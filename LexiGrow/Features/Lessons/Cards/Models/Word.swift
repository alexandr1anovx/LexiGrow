//
//  Word.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation

struct Word: Identifiable, Codable, Hashable {
  let id: UUID
  let original: String
  let translation: String
  let transcription: String
}

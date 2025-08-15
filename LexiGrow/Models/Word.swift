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
  let audioName: String
  
  enum CodingKeys: String, CodingKey {
    case id, original, translation, transcription
    case audioName = "audio_name"
  }
}

extension Word {
  static let mock = Word(
    id: UUID(),
    original: "Bus",
    translation: "Автобус",
    transcription: "ˈbəs",
    audioName: "bus"
  )
}

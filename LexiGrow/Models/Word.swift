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
  let transcription: String
  let partOfSpeech: String
  let level: String
  let topic: String
  let audioName: String
}

extension Word {
  static let mock: Word = .init(
    id: "01",
    original: "Bus",
    translation: "Автобус",
    transcription: "ˈbəs",
    partOfSpeech: "noun",
    level: "B1.1",
    topic: "Vehicles",
    audioName: "bus"
  )
}

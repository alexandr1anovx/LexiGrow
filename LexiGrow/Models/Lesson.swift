//
//  Lesson.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

enum LessonType: String {
  case flashcards = "Flashcards"
  case guessTheContext = "Guess The Context"
  case reading = "Reading"
  case writing = "Writing"
  case unknown
}

struct Lesson: Identifiable, Codable, Hashable {
  let id: String
  let name: String
  let description: String
  let iconName: String
  let isLocked: Bool
  let setupData: LessonSetupData
  
  var type: LessonType {
    return LessonType(rawValue: self.name) ?? .unknown
  }
}

struct LessonSetupData: Codable, Hashable {
  var levels: [String]
  var topics: [String]
}


extension Lesson {
  static let mock: Lesson = Lesson(
    id: "94r1",
    name: "Writing",
    description: "Learn words with spaced repetition.",
    iconName: "rectangle.stack.fill",
    isLocked: true,
    setupData: LessonSetupData(
      levels: ["A1", "A2", "B1", "B2", "C1"],
      topics: ["Politics", "Programming"]
    )
  )
  static let mock2: Lesson = Lesson(
    id: "94r1",
    name: "Flashcards",
    description: "Learn words with spaced repetition.",
    iconName: "rectangle.stack.fill",
    isLocked: false,
    setupData: LessonSetupData(
      levels: ["B1.1", "B1.2", "B2.1", "B2.2"],
      topics: ["Politics", "Programming"]
    )
  )
}

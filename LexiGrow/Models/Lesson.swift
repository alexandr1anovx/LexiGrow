//
//  Lesson.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

enum LessonType: String {
  case flashcards = "Flashcards"
  case translation = "Translation"
  case unknown
}

struct Lesson: Identifiable, Codable, Hashable {
  let id: UUID
  let name: String
  let description: String
  let iconName: String
  let isLocked: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, name, description
    case iconName = "icon_name"
    case isLocked = "is_locked"
  }
  
  var type: LessonType {
    return LessonType(rawValue: self.name) ?? .unknown
  }
}

extension Lesson {
  static let flashcards = Lesson(
    id: UUID(),
    name: "Flashcards",
    description: "Flashcards description",
    iconName: "rectangle.stack.fill",
    isLocked: false
  )
  static let reading = Lesson(
    id: UUID(),
    name: "Reading",
    description: "Reading description",
    iconName: "book.closed",
    isLocked: true
  )
}

//
//  Lesson.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUICore

struct Lesson: Identifiable, Hashable {
  let id = UUID()
  let name: String
  let description: String
  let iconName: String
  let color: Color
  let isLocked: Bool
}

extension Lesson {
  
  static let mock: Lesson = Lesson(
    name: "Flashcards",
    description: "Word ↔ Translation",
    iconName: "apple.logo",
    color: .green,
    isLocked: false
  )
  
  static let lessons: [Lesson] = [
    Lesson(
      name: "Flashcards",
      description: "Word ↔ Translation",
      iconName: "apple.logo",
      color: .green,
      isLocked: false
    ),
    Lesson(
      name: "Guess the context",
      description: "Choosing the right word for the meaning in the text.",
      iconName: "apple.logo",
      color: .green,
      isLocked: false
    ),
    Lesson(
      name: "Reading",
      description: "Just read and translate.",
      iconName: "apple.logo",
      color: .brown,
      isLocked: true
    ),
    Lesson(
      name: "Writing",
      description: "Just read and translate.",
      iconName: "apple.logo",
      color: .brown,
      isLocked: true
    )
  ]
}

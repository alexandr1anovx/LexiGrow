//
//  MockData.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 05.09.2025.
//

import Foundation

// MARK: - Level

extension Level {
  static let mockB1 = Level(id: UUID(), name: "B1", orderIndex: 1)
  static let mockB2 = Level(id: UUID(), name: "B2", orderIndex: 2)
}

// MARK: - Topic

extension Topic {
  static let mock1 = Topic(id: UUID(), name: "Daily Life", totalWords: 20, learnedWords: 0)
  static let mock2 = Topic(id: UUID(), name: "Eating", totalWords: 20, learnedWords: 10)
  static let mock3 = Topic(id: UUID(), name: "Appearance", totalWords: 20, learnedWords: 20)
}

// MARK: - Word

extension Word {
  static let mock1 = Word(id: UUID(), original: "Bus", translation: "Автобус", transcription: "ˈbəs")
  static let mock2 = Word(id: UUID(), original: "Car", translation: "Автомобіль", transcription: "kɑːr")
}

// MARK: - Lesson

extension Lesson {
  static let mockFlashcards = Lesson(
    id: UUID(),
    title: "Flashcards",
    subtitle: "Flashcards description",
    iconName: "rectangle.stack.fill",
    isLocked: false
  )
  static let mockReading = Lesson(
    id: UUID(),
    title: "Reading",
    subtitle: "Reading description",
    iconName: "book.closed",
    isLocked: true
  )
}

// MARK: - App User

extension AppUser {
  static var mockUser = AppUser(
    id: UUID(),
    fullName: "Alex",
    email: "address@mail.com",
    emailConfirmed: true
  )
}

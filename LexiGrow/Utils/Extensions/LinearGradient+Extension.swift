//
//  LinearGradient+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

extension LinearGradient {
  static let premiumBackground =
  LinearGradient(
    colors: [.orange, .cmBlack],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  static func lessonGradient(_ lesson: Lesson) -> LinearGradient {
    LinearGradient(
      colors: [lesson.color, .cmBlack],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
  static let lockedLesson = LinearGradient(
    colors: [.orange, .cmBlack],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  static let flashcardFront = LinearGradient(
    colors: [.teal, .green],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  static let flashcardBack = LinearGradient(
    colors: [.purple, .blue],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

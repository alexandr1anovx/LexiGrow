//
//  Lesson.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI
import SwiftData

enum LessonType: String {
  case flashcards = "Flashcards"
  case translation = "Translation"
  case unknown
}

// This model is only used to decode data from Supabase.
struct Lesson: Identifiable, Codable, Hashable {
  let id: UUID
  let title: String
  let subtitle: String
  let iconName: String
  let isLocked: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, title, subtitle
    case iconName = "icon_name"
    case isLocked = "is_locked"
  }
  
  var type: LessonType {
    return LessonType(rawValue: self.title) ?? .unknown
  }
}

@Model
final class LessonEntity {
  @Attribute(.unique)
  var id: UUID
  var title: String
  var subtitle: String
  var iconName: String
  var isLocked: Bool
  
  var type: LessonType {
    return LessonType(rawValue: self.title) ?? .unknown
  }
  
  init(id: UUID, title: String, subtitle: String, iconName: String, isLocked: Bool) {
    self.id = id
    self.title = title
    self.subtitle = subtitle
    self.iconName = iconName
    self.isLocked = isLocked
  }
  
  convenience init(from dto: Lesson) {
    self.init(
      id: dto.id,
      title: dto.title,
      subtitle: dto.subtitle,
      iconName: dto.iconName,
      isLocked: dto.isLocked
    )
  }
}

extension LessonEntity {
  static let mockObject = LessonEntity(
    id: UUID(),
    title: "Flashcards",
    subtitle: "Subtitle",
    iconName: "tray.badge.fill",
    isLocked: false
  )
}

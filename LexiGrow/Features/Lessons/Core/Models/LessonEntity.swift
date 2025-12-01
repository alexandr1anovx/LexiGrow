//
//  LessonEntity.swift
//  LexiGrow
//
//  Created by Oleksandr Andrianov on 01.12.2025.
//

import Foundation
import SwiftData

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
  
  convenience init(from dto: LessonDTO) {
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
  static let mock = LessonEntity(
    id: UUID(),
    title: "Картки",
    subtitle: "Вивчайте слова за допомогою інтервального повторення.",
    iconName: "tray.badge.fill",
    isLocked: false
  )
}

//
//  LessonDTO.swift
//  LexiGrow
//
//  Created by Oleksandr Andrianov on 01.12.2025.
//

import Foundation

// This model is only used to decode data from Supabase.
struct LessonDTO: Identifiable, Codable, Hashable {
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

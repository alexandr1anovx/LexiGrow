//
//  LessonContainerView.swift
//  ReWord
//
//  Created by Oleksandr Andrianov on 20.11.2025.
//

import SwiftUI

struct LessonsContainerView: View {
  @Environment(\.dismiss) var dismiss
  let lesson: LessonEntity
  
  var body: some View {
    switch lesson.type {
    case .cards:
      CardsContainerView()
    case .unknown:
      VStack {
        Label("Coming Soon", systemImage: "sparkles")
        Button("Dismiss") { dismiss() }
      }
    }
  }
}

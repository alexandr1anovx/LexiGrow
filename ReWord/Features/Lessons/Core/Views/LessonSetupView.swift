//
//  LessonSetupView.swift
//  ReWord
//
//  Created by Oleksandr Andrianov on 20.11.2025.
//

import SwiftUI

struct LessonSetupView: View {
  let lesson: LessonEntity
  @Binding var activeLesson: LessonEntity?
  
  var body: some View {
    Group {
      switch lesson.type {
      case .cards:
        CardsSetupView(lesson: lesson, activeLesson: $activeLesson)
      case .unknown:
        EmptyView()
      }
    }.presentationDetents([.fraction(0.5)])
  }
}

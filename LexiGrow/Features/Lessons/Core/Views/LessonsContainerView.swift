//
//  LessonContainerView.swift
//  LexiGrow
//
//  Created by Oleksandr Andrianov on 20.11.2025.
//

import SwiftUI

struct LessonsContainerView: View {
  @Environment(TranslationViewModel.self) var translationViewModel
  @Environment(\.dismiss) var dismiss
  let lesson: LessonEntity
  
  var body: some View {
    switch lesson.type {
    case .cards:
      CardsContainerView()
    case .translation:
      TranslationView(viewModel: translationViewModel)
    case .unknown:
      VStack {
        Label("Coming Soon", systemImage: "sparkles")
        Button("Dismiss") { dismiss() }
      }
    }
  }
}

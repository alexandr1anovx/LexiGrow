//
//  TranslationSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.08.2025.
//

import SwiftUI

struct TranslationSetupView: View {
  @Environment(\.dismiss) var dismiss
  @Bindable var viewModel: TranslationViewModel
  let lesson: LessonEntity
  @Binding var activeLesson: LessonEntity?
  
  var body: some View {
    VStack(spacing: 35) {
      Spacer()
      
      VStack(spacing: 8) {
        Label(lesson.title, systemImage: lesson.iconName)
          .font(.title)
          .fontWeight(.bold)
        Text(lesson.subtitle)
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
      HStack {
        Text("Levels:")
          .fontWeight(.medium)
        ScrollView(.horizontal) {
          HStack(spacing: 12) {
            ForEach(viewModel.levels, id: \.self) { level in
              LevelButton(
                name: level.name,
                selectedLevel: $viewModel.selectedLevel) {
                  viewModel.selectedLevel = viewModel.selectedLevel == level ? nil : level
                }
            }
          }.padding([.leading, .vertical], 8)
        }
      }
      .padding(.horizontal)
      
      Button {
        Task {
          await viewModel.startLesson()
          activeLesson = lesson
          dismiss()
        }
      } label: {
        Label("Start lesson", systemImage: "play.circle.fill")
          .prominentLabelStyle(tint: .blue)
      }
      .padding(.horizontal, 20)
      .disabled(viewModel.selectedLevel == nil)
    }
    .task {
      await viewModel.getLevels()
    }
  }
}

#Preview {
  TranslationSetupView(
    viewModel: TranslationViewModel.mock,
    lesson: .mock,
    activeLesson: .constant(.mock)
  )
}

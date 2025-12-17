//
//  CardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct CardsSetupView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(CardsViewModel.self) var viewModel
  
  let lesson: LessonEntity
  /// Passes the value of the '.fullScreenCover' modifier to the container view.
  @Binding var activeLesson: LessonEntity?
  
  var body: some View {
    NavigationView {
      VStack(spacing: 35) {
        
        Spacer()
        
        // MARK: - Lesson information
        
        VStack(spacing: 15) {
          Label(lesson.title, systemImage: lesson.iconName)
            .font(.title)
            .fontWeight(.bold)
          Text(lesson.subtitle)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
        }
        
        // MARK: - Levels and Topics
        
        VStack(spacing: 15) {
          CardsLevelStackView(viewModel: viewModel)
          CardsTopicStackView(viewModel: viewModel)
        }
        
        // MARK: - Start lesson button
        
        PrimaryLabelButton("Почати урок", iconName: "play.circle.fill") {
          Task {
            await viewModel.startLesson()
            activeLesson = lesson
            dismiss()
          }
        }
        .disabled(!viewModel.canStartLesson)
      }
      .padding(.horizontal)
      .padding(.bottom)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          CloseButton {
            dismiss()
          }
        }
      }
      .task { await viewModel.getLevels() }
      .onDisappear { viewModel.resetSetupData() }
    }
  }
}

#Preview {
  CardsSetupView(
    lesson: .mock,
    activeLesson: .constant(.mock)
  ).environment(CardsViewModel.mock)
}

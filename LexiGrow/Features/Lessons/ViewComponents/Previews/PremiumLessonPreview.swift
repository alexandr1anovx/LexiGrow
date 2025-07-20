//
//  PremiumLessonPreview.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct PremiumLessonPreview: View {
  let lesson: Lesson
  @Binding var selectedLessonForSheet: Lesson?
  
  var body: some View {
    VStack {
      Spacer()
      DescriptionText(lesson: lesson)
      Spacer()
      GetPremiumButton()
    }
    .presentationDetents([.fraction(0.38)])
    .presentationCornerRadius(50)
    .presentationBackground(lesson.color.gradient)
    .overlay(alignment: .topTrailing) {
      DismissXButton {
        selectedLessonForSheet = nil
      }
    }
  }
}

private extension PremiumLessonPreview {
  
  struct DescriptionText: View {
    let lesson: Lesson
    
    var body: some View {
      VStack(spacing: 20) {
        Label("**\(lesson.name)** is locked.", systemImage: "lock.circle.dotted")
          .font(.title2)
          .fontWeight(.semibold)
        Text("Get premium subscription to unlock this lesson.")
          .font(.headline)
          .fontWeight(.medium)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
    }
  }
  
  struct GetPremiumButton: View {
    var body: some View {
      Button {
        // action
      } label: {
        Label("Get Premium", systemImage: "star.leadinghalf.filled")
          .padding(11)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
}

#Preview {
  PremiumLessonPreview(
    lesson: Lesson.mock,
    selectedLessonForSheet: .constant(Lesson.mock)
  )
}

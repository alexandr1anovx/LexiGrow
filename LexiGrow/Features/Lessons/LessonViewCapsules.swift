//
//  LessonViewPyramide.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonViewCapsules: View {
  @State private var selectedLesson: Lesson?
  
  private let rows = [
    GridItem(.flexible(minimum: 20, maximum: 50), spacing: 13),
    GridItem(.flexible(minimum: 20, maximum: 50))
  ]
  
  var body: some View {
    VStack {
      closedLessonsHintLabel
      LazyHGrid(rows: rows, spacing: 15) {
        ForEach(Lesson.lessons, id: \.self) { lesson in
          LessonCapsule(
            lesson: lesson,
            selectedLesson: $selectedLesson
          )
        }
      }
      Button {
        // start lesson action
      } label: {
        Text("Start Lesson")
          .fontWeight(.medium)
          .foregroundStyle(.white)
          .padding(11)
      }
      .tint(.pink)
      .buttonBorderShape(.roundedRectangle(radius: 20))
      .buttonStyle(.borderedProminent)
      .disabled(selectedLesson == nil)
      .shadow(radius:10)
      
      Spacer()
    }
    .padding(.top, 20)
    .tag(DisplayMode.capsules)
  }
  
  // MARK: - Subviews
  
  private var closedLessonsHintLabel: some View {
    Label {
      HStack(spacing: 5) {
        Text("Closed lessons")
          .fontWeight(.semibold)
          .foregroundStyle(.orange)
        Text("require premium subscription.")
      }
      .font(.subheadline)
    } icon: {
      Image(systemName: "lock.fill")
        .foregroundStyle(.orange)
    }
  }
}

#Preview {
  LessonViewCapsules()
}

struct LessonCapsule: View {
  let lesson: Lesson
  @Binding var selectedLesson: Lesson?
  
  var body: some View {
    Button {
      if !lesson.isLocked {
        withAnimation {
          if selectedLesson == lesson {
            selectedLesson = nil
          } else {
            selectedLesson = lesson
          }
        }
      }
    } label: {
      HStack(spacing: 8) {
        Text(lesson.name)
          .font(.headline)
        if lesson.isLocked {
          Image(systemName: "lock.fill")
            .font(.footnote)
            .foregroundStyle(.orange)
        }
      }
      .padding(13)
      .foregroundColor(.white)
      .background(
        RoundedRectangle(cornerRadius: 15)
          .fill(selectedLesson == lesson ? .pink : .cmBlack)
          .stroke(
            selectedLesson == lesson ? .clear : .white,
            lineWidth: 2
          )
          .shadow(radius: 10)
      )
    }.disabled(lesson.isLocked)
  }
  
  private func capsuleForeground(for lesson: Lesson) -> Color {
    if selectedLesson == lesson {
      return .white
    } else {
      return .white
    }
  }
  
  private func capsuleBackground(for lesson: Lesson) -> Color {
    if selectedLesson == lesson {
      return .pink
    } else {
      return .cmBlack
    }
  }
  
  private func capsuleStroke(for lesson: Lesson) -> Color {
    if selectedLesson == lesson {
      return .clear
    } else {
      return .white
    }
  }
}

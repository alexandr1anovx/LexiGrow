//
//  LessonViewPyramide.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonViewCapsules: View {
  @Environment(\.colorScheme) var colorScheme
  @State private var selectedLesson: Lesson?
  
  let rows = [
    GridItem(.flexible(minimum: 20, maximum: 50)),
    GridItem(.flexible(minimum: 20, maximum: 50))
  ]
  
  var body: some View {
    VStack {
      LazyHGrid(rows: rows, alignment: .center, spacing: 15) {
        ForEach(Lesson.lessons, id: \.self) { lesson in
          capsuleButton(for: lesson)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: 160)
      
      Button {
        // action
      } label: {
        Text("Start Lesson")
          .linearGradientButtonStyle()
      }
      .opacity(selectedLesson == nil ? 0.5 : 1)
      .disabled(selectedLesson == nil)
      .shadow(radius: 5)
      
      Spacer()
    }
  }
  
  // MARK: - Subviews
  
  private var hintsView: some View {
    Label {
      Text("**Closed lessons** require premium subscription.")
        .font(.footnote)
    } icon: {
      Image(systemName: "lock.fill")
        .foregroundStyle(.secondary)
    }
  }
  
  private func capsuleButton(for lesson: Lesson) -> some View {
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
      HStack(spacing: 5) {
        Text(lesson.name)
          .font(.subheadline)
          .fontWeight(.medium)
        if lesson.isLocked {
          Image(systemName: "lock.fill")
            .font(.footnote)
        }
      }
      .foregroundColor(capsuleForeground(for: lesson))
      .padding(.vertical, 13)
      .padding(.horizontal, 15)
      .background(
        Capsule()
          .fill(capsuleBackground(for: lesson))
          .overlay(
            Capsule()
              .stroke(capsuleBorder(for: lesson), lineWidth: 3)
              .shadow(radius: 2)
          )
      )
    }.disabled(lesson.isLocked)
  }
  
  // MARK: - Styling helpers
  
  private func capsuleForeground(for lesson: Lesson) -> Color {
    if lesson.isLocked {
      return .primary
    } else if selectedLesson == lesson {
      return colorScheme == .light ? .white : .black
    } else {
      return .primary
    }
  }
  
  private func capsuleBackground(for lesson: Lesson) -> Color {
    if selectedLesson == lesson && !lesson.isLocked {
      return colorScheme == .light ? .black : .white
    } else {
      return Color.clear
    }
  }
  
  private func capsuleBorder(for lesson: Lesson) -> AnyGradient {
    if selectedLesson == lesson && !lesson.isLocked {
      return Color.primary.gradient
    } else if lesson.isLocked {
      return Color.primary.opacity(0.2).gradient
    } else {
      return lesson.color.gradient
    }
  }
}

#Preview {
  LessonViewCapsules()
}

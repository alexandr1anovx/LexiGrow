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
      Text("Select a lesson to begin learning.")
        .fontWeight(.semibold)
      hintsView.padding(.top)
      
      LazyHGrid(rows: rows, alignment: .center, spacing: 15) {
        ForEach(Lesson.lessons, id: \.self) { lesson in
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
            .foregroundColor(foreground(for: lesson))
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(
              Capsule()
                .fill(background(for: lesson))
                .overlay(
                  Capsule()
                    .stroke(border(for: lesson), lineWidth: 3)
                    .shadow(radius: 2)
                )
            )
          }.disabled(lesson.isLocked)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: 160)
      
      Button {
        // action
      } label: {
        Text("Begin Lesson")
          .padding(.horizontal,8)
          .padding(.vertical,8)
          .fontWeight(.medium)
          .foregroundStyle(colorScheme == .light ? .white : .black)
      }
      .tint(colorScheme == .light ? .black : .white)
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.capsule)
      .shadow(radius: 5)
      .opacity(selectedLesson == nil ? 0.5 : 1)
      
      Spacer()
    }
  }
  
  // MARK: - Styling helpers
  
  private var hintsView: some View {
    Label {
      Text("**Closed lessons** require premium subscription.")
        .font(.footnote)
    } icon: {
      Image(systemName: "lock.fill")
        .foregroundStyle(.secondary)
    }
  }
  
  private func foreground(for lesson: Lesson) -> Color {
    if lesson.isLocked {
      return .primary
    } else if selectedLesson == lesson {
      return colorScheme == .light ? .white : .black
    } else {
      return .primary
    }
  }
  
  private func background(for lesson: Lesson) -> Color {
    if selectedLesson == lesson && !lesson.isLocked {
      return colorScheme == .light ? .black : .white
    } else {
      return Color.clear
    }
  }
  
  private func border(for lesson: Lesson) -> Color {
    if selectedLesson == lesson && !lesson.isLocked {
      return Color.clear
    } else if lesson.isLocked {
      return Color.primary.opacity(0.5)
    } else {
      return Color.blue
    }
  }
}

#Preview {
  LessonViewCapsules()
}

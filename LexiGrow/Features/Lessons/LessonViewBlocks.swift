//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonViewBlocks: View {
  @State private var selectedLesson: Lesson?
  
  private let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 18),
    GridItem(.flexible(), spacing: 18)
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(Lesson.lessons) { lesson in
          BlockView(lesson: lesson)
            .onTapGesture {
              selectedLesson = lesson
            }
        }
      }
    }
    .shadow(
      color: .primary.opacity(0.7),
      radius: 0.5,
      x: 4, y: -3
    )
    .tag(DisplayMode.blocks)
    .padding()
    .shadow(radius: 5)
    .sheet(item: $selectedLesson) { lesson in
      Group {
        if lesson.isLocked {
          lockedLessonPreview(lesson)
        } else {
          lessonPreview(lesson)
        }
      }
      .presentationBackground(
        LinearGradient(
          colors: [lesson.color, .teal],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
    }
  }
  
  // MARK: - Subviews
  
  private func lessonPreview(_ lesson: Lesson) -> some View {
    VStack(spacing:15) {
      Spacer()
      Text(lesson.name)
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
      Text(lesson.description)
        .font(.callout)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white.secondary)
        .padding(.horizontal)
      Spacer()
      Button {
        
      } label: {
        Text("Start Lesson")
          .standardButtonStyle(bgColor: lesson.color)
      }.padding(.bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
    .overlay(alignment: .topTrailing) {
      Button {
        selectedLesson = nil
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title)
          .foregroundStyle(.white)
          .symbolRenderingMode(.hierarchical)
      }.padding(20)
    }
  }
  
  private func lockedLessonPreview(_ lesson: Lesson) -> some View {
    VStack(spacing:18) {
      Label("**\(lesson.name)** is locked.", systemImage: "lock.circle.dotted")
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
      Text("Get premium subscription to unlock this lesson.")
        .font(.headline)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
        .padding(.horizontal)
      Button {
        
      } label: {
        Label("Get Premium", systemImage: "star.leadinghalf.filled")
          .fontWeight(.bold)
          .standardButtonStyle(bgColor: .green.opacity(0.8))
      }.padding(.top)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
    .overlay(alignment: .topTrailing) {
      Button {
        selectedLesson = nil
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title)
          .foregroundStyle(.white)
          .symbolRenderingMode(.hierarchical)
      }.padding(20)
    }
  }
}

struct BlockView: View {
  let lesson: Lesson
  @State private var isShownDescriptionPopover: Bool = false
  
  var body: some View {
    HStack {
      Text(lesson.name)
        .font(.headline)
        .fontDesign(.monospaced)
        .foregroundColor(.white)
        .padding()
      Spacer()
      if lesson.isLocked {
        Image(systemName: "lock.circle.dotted")
          .font(.title)
          .padding(.trailing,8)
          .foregroundStyle(.white)
          .onTapGesture {
            isShownDescriptionPopover.toggle()
          }
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(
          LinearGradient(
            colors: [lesson.color, .teal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
    )
    .frame(height: 150)
    .popover(
      isPresented: $isShownDescriptionPopover,
      attachmentAnchor: .point(.top),
      arrowEdge: .bottom) {
        Text("Available with premium subscription.")
          .font(.footnote)
          .fontWeight(.medium)
          .foregroundStyle(.primary)
          .multilineTextAlignment(.leading)
          .presentationBackground(lesson.color.opacity(0.3))
          .presentationCompactAdaptation(.popover)
          .padding(.horizontal)
      }
  }
}

#Preview {
  LessonViewBlocks()
}

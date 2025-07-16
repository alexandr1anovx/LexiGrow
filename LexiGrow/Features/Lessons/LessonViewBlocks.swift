//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonViewBlocks: View {
  @State var viewModel = FlashcardsViewModel()
  @State private var selectedLessonForSheet: Lesson?
  @State private var selectedLessonForFullScreenCover: Lesson?
  
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
              viewModel.resetLesson()
              selectedLessonForSheet = lesson
//              if !lesson.isLocked {
//                viewModel.resetLesson()
//                selectedLessonForSheet = lesson
//              }
            }
        }
      }
    }
    .tag(DisplayMode.blocks)
    .padding()
    
    // MARK: - Presentation
    
    .sheet(item: $selectedLessonForSheet) { lesson in
      if !lesson.isLocked {
        lessonPreview(lesson)
      } else {
        lockedLessonPreview(lesson)
      }
    }
    .fullScreenCover(item: $selectedLessonForFullScreenCover) { lesson in
      switch lesson.name {
      case "Flashcards":
        FlashcardsGroupView(viewModel: viewModel)
      case "Guess the context":
        GuessTheContextView()
      default:
        EmptyView()
      }
    }
    .shadow(
      color: .cmReversed.opacity(0.7),
      radius: 0.5,
      x: 4, y: -3
    )
  }
  
  // MARK: - Subviews
  
  private func lessonPreview(_ lesson: Lesson) -> some View {
    Group {
      switch lesson.name {
        case "Flashcards":
        FlashcardsSetupView(lesson: lesson, viewModel: viewModel, selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover)
          .presentationDetents([.fraction(0.38)])
          .presentationCornerRadius(50)
          .presentationBackgroundInteraction(.disabled)
        case "Guess the context":
        GuessTheContextView()
      default:
        EmptyView()
      }
    }
  }
  
  private func lockedLessonPreview(_ lesson: Lesson) -> some View {
    VStack(spacing: 20) {
      Spacer()
      Label("**\(lesson.name)** is locked.", systemImage: "lock.circle.dotted")
        .font(.title2)
        .fontWeight(.semibold)
        
      Text("Get premium subscription to unlock this lesson.")
        .font(.headline)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      Spacer()
      Button {
        // action
      } label: {
        Label("Get Premium", systemImage: "star.leadinghalf.filled")
          .fontWeight(.bold)
          .padding(11)
      }
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.roundedRectangle(radius: 20))
      .tint(.pink)
      .padding(.bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.fraction(0.35)])
    .presentationCornerRadius(50)
    .presentationBackground(
      LinearGradient(
        colors: [.orange, .cmSystem],
        startPoint: .top,
        endPoint: .bottom
      )
    )
    .overlay(alignment: .topTrailing) {
      Button {
        selectedLessonForSheet = nil
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title)
          .symbolRenderingMode(.hierarchical)
      }.padding(20)
    }
  }
}

// MARK: - Block View

struct BlockView: View {
  let lesson: Lesson
  @State private var isShownDescriptionPopover: Bool = false
  
  @State var counter: Int = 0
  @State var origin: CGPoint = .zero
  
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
          .padding(.trailing, 8)
          .foregroundStyle(.white)
          .onTapGesture {
            isShownDescriptionPopover.toggle()
          }
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(lesson.isLocked ? LinearGradient.lockedLesson : LinearGradient.lessonGradient(lesson))
        .onPressingChanged { point in
            if let point {
                origin = point
                counter += 1
            }
        }
        .modifier(
          RippleEffect(
            at: origin,
            trigger: counter
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
          .foregroundStyle(.cmBlack)
          .multilineTextAlignment(.leading)
          .presentationBackground(.orange.opacity(0.5))
          .presentationCompactAdaptation(.popover)
          .padding(.horizontal)
      }
  }
}

#Preview {
  LessonViewBlocks()
}

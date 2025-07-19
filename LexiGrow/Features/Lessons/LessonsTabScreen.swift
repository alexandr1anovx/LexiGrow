//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonsTabScreen: View {
  @State var viewModel = FlashcardsViewModel()
  @State private var selectedLessonForSheet: Lesson?
  @State private var selectedLessonForFullScreenCover: Lesson?
  
  private let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.mainBackgroundColor
          .ignoresSafeArea()
        ScrollView {
          LazyVGrid(columns: columns, spacing: 25) {
            ForEach(Lesson.lessons) { lesson in
              LessonBlockView(lesson: lesson)
                .onTapGesture {
                  viewModel.resetLesson()
                  selectedLessonForSheet = lesson
                }
            }
          }.padding()
        }.padding(.top)
      }
      .navigationTitle("Lessons")
      .navigationBarTitleDisplayMode(.large)
      .sheet(item: $selectedLessonForSheet) { lesson in
        if !lesson.isLocked {
          FreeLessonPreview(
            lesson: lesson,
            viewModel: viewModel,
            selectedLessonForFullScreenCover: $selectedLessonForFullScreenCover
          )
        } else {
          PremiumLessonPreview(
            lesson: lesson,
            selectedLessonForSheet: $selectedLessonForSheet
          )
        }
      }
      .fullScreenCover(item: $selectedLessonForFullScreenCover) { lesson in
        switch lesson.name {
        case "Flashcards":
          FlashcardGroupView(viewModel: viewModel)
        case "Guess the context":
          GuessTheContextView()
        default:
          EmptyView()
        }
      }
    }
  }
}

#Preview {
  LessonsTabScreen(
    viewModel: FlashcardsViewModel()
  )
}

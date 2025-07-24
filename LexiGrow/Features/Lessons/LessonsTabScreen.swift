//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonsTabScreen: View {
  @Environment(FlashcardsViewModel.self) var viewModel
  @State private var selectedLessonForSheet: Lesson?
  @State private var selectedLessonForFullScreenCover: Lesson?
  
  private let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 15),
    GridItem(.flexible(), spacing: 15)
  ]
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.mainBackgroundColor.ignoresSafeArea()
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 25) {
            ForEach(Lesson.lessons) { lesson in
              if lesson.isLocked {
                PremiumLessonBlock(lesson: lesson)
                  .onTapGesture {
                    selectedLessonForSheet = lesson
                  }
              } else {
                FreeLessonBlock(lesson: lesson)
                  .onTapGesture {
                    selectedLessonForSheet = lesson
                  }
              }
            }
          }.padding()
        }.padding(.top)
      }
      .navigationTitle("Lessons")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            //
          } label: {
            Image(.stars)
              .foregroundStyle(.pink.gradient)
          }
        }
      }
      .sheet(item: $selectedLessonForSheet) { lesson in
        if !lesson.isLocked {
          FreeLessonPreview(
            lesson: lesson,
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
          FlashcardContainerView()
        case "Guess the context":
          GuessTheContextContainerView()
        default:
          EmptyView()
        }
      }
    }
  }
}

#Preview {
  LessonsTabScreen()
    .environment(FlashcardsViewModel())
    .environment(GuessTheContextViewModel())
}

//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardSetupView: View {
  @Environment(\.dismiss) private var dismiss // hides setup sheet
  @Environment(FlashcardViewModel.self) var viewModel
  let lesson: LessonEntity // selected lesson
  @Binding var activeLesson: LessonEntity? // passes the value of the '.fullScreenCover' modifier to the container view.
  
  @State private var showMenu = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {
        Spacer()
        // Title
        VStack(spacing: 8) {
          Label(lesson.title, systemImage: lesson.iconName)
            .font(.title)
            .fontWeight(.bold)
          Text(lesson.subtitle)
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        
        // Selectable content
        VStack(spacing: 13) {
          LevelsView(viewModel: viewModel)
          TopicsView(viewModel: viewModel)
            .frame(height: 45)
        }
        .padding(.horizontal)
        
        // Start button
        Button {
          viewModel.startLesson()
          activeLesson = lesson
          dismiss()
        } label: {
          Label("Start lesson", systemImage: "play.circle.fill")
            .prominentButtonStyle(tint: .pink)
        }
        .padding([.horizontal, .bottom], 25)
        .disabled(!viewModel.canStartLesson)
        .opacity(!viewModel.canStartLesson ? 0.5 : 1)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          DismissXButton {
            dismiss()
          }.padding(.top)
        }
        ToolbarItem(placement: .topBarLeading) {
          SortMenuView(viewModel: viewModel)
        }
      }
      .onAppear {
        viewModel.getLevels()
      }
      .onDisappear {
        viewModel.resetLessonSetupData()
      }
    }
  }
}

extension FlashcardSetupView {
  struct SortMenuView: View {
    @Bindable var viewModel: FlashcardViewModel
    var body: some View {
      Menu {
        Picker("Sort by", selection: $viewModel.sortOption) {
          ForEach(TopicSortOption.allCases) { option in
            Label(option.rawValue, systemImage: option.iconName)
              .tag(option)
          }
        }
      } label: {
        Image(systemName: "gearshape")
          .imageScale(.large)
          .foregroundStyle(.white)
          .padding(3)
          .background {
            RoundedRectangle(cornerRadius: 12)
              .fill(.black)
              .shadow(radius: 3)
          }
      }
      .padding(.top, 20)
      .padding(.leading, 8)
    }
  }
}


#Preview {
  FlashcardSetupView(
    lesson: .mockObject,
    activeLesson: .constant(.mockObject)
  )
  .environment(FlashcardViewModel.mockObject)
}

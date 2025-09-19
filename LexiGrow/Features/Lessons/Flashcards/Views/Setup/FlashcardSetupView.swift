//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardSetupView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(FlashcardViewModel.self) var viewModel
  let lesson: LessonEntity
  /// Passes the value of the '.fullScreenCover' modifier to the container view.
  @Binding var activeLesson: LessonEntity?
  @State private var showMenu = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {
        Spacer()
        // Title
        VStack(spacing: 10) {
          Label(lesson.title, systemImage: lesson.iconName)
            .font(.title)
            .fontWeight(.bold)
          Text(lesson.subtitle)
            .font(.subheadline)
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
        if #available(iOS 26.0, *) {
          Button {
            viewModel.startLesson()
            activeLesson = lesson
            dismiss()
          } label: {
            Label("Start lesson", systemImage: "play.circle.fill")
              .padding(10)
              .fontWeight(.medium)
              .frame(maxWidth: .infinity)
          }
          .tint(.pink)
          .buttonStyle(.glassProminent)
          .padding(.horizontal, 25)
          .disabled(!viewModel.canStartLesson)
          .opacity(!viewModel.canStartLesson ? 0.3 : 1)
        } else {
          // Fallback on earlier versions
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          DismissXButton {
            dismiss()
          }
        }
        ToolbarItem(placement: .topBarLeading) {
          SortMenuView(viewModel: viewModel)
        }
      }
      .onAppear {
        viewModel.getLevels()
      }
      .onDisappear {
        viewModel.resetSetupData()
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
        if #available(iOS 26, *) {
          Image(systemName: "gearshape")
            .imageScale(.large)
        } else {
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
      }
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

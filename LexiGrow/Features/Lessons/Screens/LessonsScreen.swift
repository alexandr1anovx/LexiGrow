//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI
import SwiftData



struct LessonsScreen: View {
  @Environment(\.modelContext) var modelContext
  @Environment(AuthManager.self) var authManager
  @Environment(LessonsViewModel.self) var viewModel
  
  @State private var selectedLesson: LessonEntity? // for sheet
  @State private var activeLesson: LessonEntity? // for .fullScreenCover
  @State private var displayMode: DisplayMode = .lessons
  
  var body: some View {
    VStack {
      Text("Привіт 😊,  \(authManager.currentUser?.firstName ?? "користувач")!")
        .font(.title3)
        .fontWeight(.semibold)
        .lineLimit(1)
        .padding(23)
      
      DisplayModeSelector(displayMode: $displayMode)
      
      Spacer()
      
      Group {
        switch displayMode {
        case .lessons:
          LessonsGridView(selectedLesson: $selectedLesson)
        case .progress:
          LessonProgressScreen()
        }
      }.transition(.blurReplace)
      
      Spacer()
    }
    .animation(.easeInOut, value: displayMode)
    .onDisappear {
      // always return user to the first tab
      displayMode = .lessons
    }
    .sheet(item: $selectedLesson) { lesson in
      LessonSetupView(lesson: lesson, activeLesson: $activeLesson)
    }
    .fullScreenCover(item: $activeLesson) { lesson in
      LessonsContainerView(lesson: lesson)
    }
    .task {
      await viewModel.syncData(context: modelContext)
    }
  }
}

private enum DisplayMode: String, Identifiable, CaseIterable {
  case lessons = "Уроки"
  case progress = "Мій прогрес"
  
  var id: Self { self }
  var iconName: String {
    switch self {
    case .lessons: "book.closed"
    case .progress: "chart.bar"
    }
  }
}

private struct DisplayModeSelector: View {
  @Binding var displayMode: DisplayMode
  @State private var triggerSelection = false
  
  var body: some View {
    HStack(spacing: 6) {
      ForEach(DisplayMode.allCases) { mode in
        DisplayModeButton(mode: mode, isSelected: displayMode == mode) {
          displayMode = mode
          triggerSelection.toggle()
        }
      }
    }
    .padding(5)
    .background {
      Capsule()
        .fill(.thinMaterial)
        .shadow(radius: 2)
    }.padding(.bottom)
  }
}

private struct DisplayModeButton: View {
  let mode: DisplayMode
  let isSelected: Bool
  let selectAction: () -> Void
  @State private var shouldAnimate = false
  
  var body: some View {
    Button {
      selectAction()
      if !isSelected {
        shouldAnimate.toggle()
      }
    } label: {
      Label(mode.rawValue, systemImage: isSelected ? "\(mode.iconName).fill" : mode.iconName)
        .symbolEffect(.bounce, value: shouldAnimate)
        .font(.subheadline)
        .foregroundStyle(isSelected ? .white : .primary)
        .capsuleLabelStyle(pouring: isSelected ? .mainGreen : .clear)
    }
  }
}

private struct LessonsGridView: View {
  @Environment(LessonsViewModel.self) var viewModel
  @Binding var selectedLesson: LessonEntity?
  
  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    if viewModel.isLoading {
      DefaultProgressView()
    } else {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 25) {
          ForEach(viewModel.lessons) { lesson in
            LessonBlockView(lesson: lesson)
              .onTapGesture { selectedLesson = lesson }
          }
        }.padding()
      }
    }
  }
}

#Preview {
  LessonsScreen()
    .environment(CardsViewModel.mock)
    .environment(LessonProgressViewModel.mock)
    .environment(LessonsViewModel.mock)
    .environment(EducationService.mock)
    .environment(AuthManager.mock)
    .environment(TranslationViewModel.mock)
}

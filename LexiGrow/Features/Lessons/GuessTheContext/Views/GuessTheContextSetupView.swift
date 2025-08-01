//
//  GuessTheContextSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 31.07.2025.
//

import SwiftUI

//struct GuessTheContextSetupView: View {
//  
//  @Environment(\.dismiss) private var dismiss
//  @Environment(GuessTheContextViewModel.self) var viewModel
//  let lesson: Lesson
//  @Binding var selectedLessonForFullScreenCover: Lesson?
//  
//  var body: some View {
//    NavigationView {
//      ZStack {
//        Color.mainBackgroundColor.ignoresSafeArea()
//        
//        VStack(spacing: 30) {
//          Spacer()
//          TitleView(for: lesson)
//          VStack(spacing: 10) {
//            LevelsView(viewModel: viewModel)
//            TopicsView(viewModel: viewModel)
//          }
//          .padding(.horizontal)
//          StartButton {
//            viewModel.startLesson()
//            selectedLessonForFullScreenCover = lesson
//            dismiss()
//          }
//        }
//        .toolbar {
//          ToolbarItem(placement: .destructiveAction) {
//            DismissXButton {
//              dismiss()
//              //viewModel.resetSetupSettings()
//            }
//          }
//        }
//      }
//    }
//  }
//}
//
//private extension GuessTheContextSetupView {
//  
//  struct TitleView: View {
//    let lesson: Lesson
//    init(for lesson: Lesson) {
//      self.lesson = lesson
//    }
//    var body: some View {
//      VStack(spacing: 8) {
//        Label(lesson.setupData.title, systemImage: lesson.iconName)
//          .font(.system(size: 25))
//          .fontWeight(.bold)
//        Text(lesson.setupData.subtitle)
//          .font(.footnote)
//          .foregroundStyle(.secondary)
//      }
//    }
//  }
//  
//  struct StartButton: View {
//    @Environment(GuessTheContextViewModel.self) var viewModel
//    var action: () -> Void
//    
//    var body: some View {
//      Button(action: action) {
//        Label("Start lesson", systemImage: "play.circle.fill")
//          .padding(12)
//      }
//      .prominentButtonStyle(tint: .pink)
//      //.disabled(viewModel.selectedLevel == nil || viewModel.selectedTopic == nil)
//    }
//  }
//  
//  struct TopicsView: View {
//    @Bindable var viewModel: GuessTheContextViewModel
//    
//    var body: some View {
//      SelectionScrollView(label: "Topic:") {
//        if viewModel.selectedLevel != nil && viewModel.availableTopics.isEmpty {
//          Text("No topics available yet")
//            .foregroundColor(.white)
//            .padding(15)
//            .background(.gray)
//            .clipShape(.capsule)
//        } else if viewModel.selectedLevel == nil {
//          Text("Select a level above")
//            .foregroundColor(.white)
//            .padding(15)
//            .background(.gray)
//            .clipShape(.capsule)
//        } else {
//          ForEach(viewModel.availableTopics, id: \.self) { topic in
//            SelectableButton(
//              content: topic,
//              selectedContent: $viewModel.selectedTopic,
//              activeColor: .orange
//            ) {
//              if viewModel.selectedTopic == topic {
//                viewModel.selectedTopic = nil
//              } else {
//                viewModel.selectedTopic = topic
//              }
//            }
//          }
//        }
//      }
//      .onAppear {
//        viewModel.resetTopics()
//      }
//      .onChange(of: viewModel.selectedLevel) {
//        viewModel.resetTopics()
//      }
//    }
//  }
//  
//  struct LevelsView: View {
//    @Bindable var viewModel: GuessTheContextViewModel
//    
//    var body: some View {
//      SelectionScrollView(label: "Level:") {
//        ForEach(viewModel.levels, id: \.self) { level in
//          SelectableButton(
//            content: level,
//            selectedContent: $viewModel.selectedLevel,
//            activeColor: .pink
//          ) {
//            if viewModel.selectedLevel == level {
//              viewModel.selectedLevel = nil
//            } else {
//              viewModel.selectedLevel = level
//              viewModel.selectedTopic = nil // reset the selected topic
//            }
//          }
//        }
//      }
//    }
//  }
//}
//
//#Preview {
//  GuessTheContextSetupView(
//    lesson: Lesson.mock,
//    selectedLessonForFullScreenCover: .constant(.mock)
//  )
//  .environment(GuessTheContextViewModel.previewMode)
//}

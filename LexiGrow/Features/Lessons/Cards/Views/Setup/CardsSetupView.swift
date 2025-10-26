//
//  CardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct CardsSetupView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(CardsViewModel.self) var viewModel
  let lesson: LessonEntity
  /// Passes the value of the '.fullScreenCover' modifier to the container view.
  @Binding var activeLesson: LessonEntity?
  @State private var showMenu = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {
        VStack(spacing: 15) {
          Label {
            Text(lesson.title)
              .fontWeight(.semibold)
          } icon: {
            Image(systemName: lesson.iconName)
              //.foregroundStyle(.mainGreen)
          }
            .font(.title2)
            
          Text(lesson.subtitle)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
        }
        
        VStack(spacing: 12) {
          CardsLevelStackView(viewModel: viewModel)
          CardsTopicStackView(viewModel: viewModel)
            .frame(height: 45)
        }
        .padding(.horizontal)
        
        PrimaryLabelButton("Почати урок", iconName: "play.circle.fill") {
          Task {
            await viewModel.startLesson()
            activeLesson = lesson
            dismiss()
          }
        }
        .padding(.horizontal)
        .disabled(!viewModel.canStartLesson)
        .opacity(!viewModel.canStartLesson ? 0.5 : 1)
      }
      .padding(.bottom,8)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          CloseButton {
            dismiss()
          }
        }
        ToolbarItem(placement: .topBarLeading) {
          SortMenuView(viewModel: viewModel)
        }
      }
      .task {
        await viewModel.getLevels()
      }
      .onDisappear {
        viewModel.resetSetupData()
      }
    }
  }
}

extension CardsSetupView {
  struct SortMenuView: View {
    @Bindable var viewModel: CardsViewModel
    @AppStorage("topic_sort_option") private var topicSortOption: TopicSortOption = .defaultOrder
    
    var body: some View {
      Menu {
        Picker("Sort by", selection: $viewModel.topicSortOption) {
          ForEach(TopicSortOption.allCases) {
            Label($0.rawValue, systemImage: $0.iconName)
              .tag($0)
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
      .onAppear {
        viewModel.topicSortOption = topicSortOption
      }
      .onChange(of: topicSortOption) { _, newValue in
        if viewModel.topicSortOption != newValue {
          viewModel.topicSortOption = newValue
        }
      }
    }
  }
}


#Preview {
  CardsSetupView(
    lesson: .mock,
    activeLesson: .constant(.mock)
  )
  .environment(CardsViewModel.mock)
}

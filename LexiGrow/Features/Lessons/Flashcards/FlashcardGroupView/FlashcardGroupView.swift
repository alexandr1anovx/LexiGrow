//
//  FlashcardsGroupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardGroupView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(FlashcardsViewModel.self) var viewModel
  @State private var isShowingExitView: Bool = false
  
  var body: some View {
    NavigationView {
      Group {
        switch viewModel.lessonState {
        case .inProgress:
          FlashcardView()
        case .summary:
          FlashcardSummaryView()
        case .tryAgain:
          FlashcardTryAgainView()
        }
      }
      .navigationTitle("Flashcards")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        if viewModel.lessonState == .inProgress {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              isShowingExitView = true
            } label: {
              Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundStyle(.pink)
                .symbolRenderingMode(.hierarchical)
            }
          }
        }
      }
      .sheet(isPresented: $isShowingExitView) {
        FinishLessonPreview {
          dismiss()
          viewModel.selectedLevel = nil
          viewModel.selectedTopic = nil
        }
      }
    }
  }
}

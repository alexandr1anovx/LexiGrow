//
//  FlashcardsGroupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardsGroupView: View {
  
  @Bindable var viewModel: FlashcardsViewModel
  @State private var isShowingExitView: Bool = false
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      Group {
        switch viewModel.lessonState {
        case .inProgress:
          FlashcardsView(viewModel: viewModel)
        case .summary:
          FlashcardsSummaryView(viewModel: viewModel) {
            dismiss()
          }
        case .tryAgain:
          FlashcardsTryAgainView(viewModel: viewModel) {
            dismiss()
          }
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
        ExitLessonView {
          dismiss()
        }
      }
    }
  }
}

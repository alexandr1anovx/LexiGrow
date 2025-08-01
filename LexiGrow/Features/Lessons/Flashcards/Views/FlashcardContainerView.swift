//
//  FlashcardsGroupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardContainerView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(FlashcardsViewModel.self) var viewModel
  @State private var isShowingFinishPreview: Bool = false
  
  var body: some View {
    NavigationView {
      Group {
        switch viewModel.lessonState {
        case .inProgress:
          FlashcardView()
        case .summary:
          FlashcardSummaryView()
        }
      }
      .navigationTitle("Flashcards")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        if viewModel.lessonState == .inProgress {
          ToolbarItem(placement: .destructiveAction) {
            DismissXButton {
              isShowingFinishPreview = true
            }.padding(.top)
          }
        }
      }
      .sheet(isPresented: $isShowingFinishPreview) {
        FinishLessonPreview {
          dismiss()
          viewModel.resetSetupSettings()
        }
        .presentationDetents([.fraction(0.37)])
        .presentationCornerRadius(50)
      }
    }
  }
}

#Preview {
  FlashcardContainerView()
    .environment(FlashcardsViewModel.previewMode)
}

//
//  FlashcardsGroupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardContainerView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(FlashcardViewModel.self) var viewModel
  @State private var showFinishSheet = false
  
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
      .animation(.easeInOut, value: viewModel.lessonState)
      .navigationTitle("Flashcards")
      .navigationBarTitleDisplayMode(viewModel.lessonState == .inProgress ? .large : .inline)
      .toolbar {
        if viewModel.lessonState == .inProgress {
          ToolbarItem(placement: .destructiveAction) {
            DismissXButton {
              showFinishSheet = true
            }.padding(.top)
          }
        }
      }
      .sheet(isPresented: $showFinishSheet) {
        FinishLessonSheet {
          dismiss()
          viewModel.resetLessonSetupData()
        }
        .presentationDetents([.fraction(0.37)])
        .presentationCornerRadius(50)
      }
    }
  }
}

#Preview {
  FlashcardContainerView()
    .environment(FlashcardViewModel.mockObject)
}

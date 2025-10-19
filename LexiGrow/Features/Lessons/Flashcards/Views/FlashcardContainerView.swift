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
          CardView()
        case .summary:
          FlashcardSummaryView()
        }
      }
      .navigationTitle("Flashcards")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        if viewModel.lessonState == .inProgress {
          ToolbarItem(placement: .topBarTrailing) {
            DismissXButton {
              showFinishSheet = true
            }
          }
        }
      }
      .sheet(isPresented: $showFinishSheet) {
        FinishLessonSheet {
          dismiss()
          viewModel.resetSetupData()
        }
        .presentationDetents([.fraction(0.35)])
        .presentationCornerRadius(50)
      }
    }
  }
}

#Preview {
  FlashcardContainerView()
    .environment(FlashcardViewModel.mockObject)
}

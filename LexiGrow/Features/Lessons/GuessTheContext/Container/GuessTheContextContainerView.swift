//
//  GuessTheContextContainerView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 23.07.2025.
//

import SwiftUI

struct GuessTheContextContainerView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(GuessTheContextViewModel.self) var viewModel
  @State private var isShowingFinishPreview: Bool = false
  
  var body: some View {
    NavigationView {
      Group {
        switch viewModel.lessonState {
        case .inProgress:
          GuessTheContextView()
        case .summary:
          GuessTheContextSummaryView()
        }
      }
      .navigationTitle("Guess The Context")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        if viewModel.lessonState == .inProgress {
          ToolbarItem(placement: .topBarTrailing) {
            DismissXButton {
              isShowingFinishPreview = true
            }
          }
        }
      }
      .sheet(isPresented: $isShowingFinishPreview) {
        FinishLessonPreview {
          dismiss()
        }
      }
    }
  }
}

#Preview {
  GuessTheContextContainerView()
    .environment(GuessTheContextViewModel.previewMode)
}

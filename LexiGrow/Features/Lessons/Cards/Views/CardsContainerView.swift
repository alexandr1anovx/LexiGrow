//
//  CardsGroupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct CardsContainerView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(CardsViewModel.self) var viewModel
  @State private var showFinishConfirmationView = false
  
  var body: some View {
    NavigationView {
      Group {
        switch viewModel.lessonState {
        case .inProgress:
          CardLessonView()
        case .summary:
          CardsSummaryView()
        }
      }
      .navigationTitle("Картки")
      .navigationBarTitleDisplayMode(viewModel.lessonState == .summary ? .inline : .large)
      .toolbar {
        if viewModel.lessonState == .inProgress {
          ToolbarItem(placement: .cancellationAction) {
            CloseButton {
              showFinishConfirmationView = true
            }
          }
        }
      }
      .sheet(isPresented: $showFinishConfirmationView) {
        FinishLessonConfirmationView {
          dismiss()
          viewModel.resetSetupData()
        }
        .presentationDetents([.fraction(0.35)])
      }
    }
  }
}

#Preview {
  CardsContainerView()
    .environment(CardsViewModel.mock)
}

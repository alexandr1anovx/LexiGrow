//
//  ReturnHomeButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension FlashcardSummaryView {
  
  struct ReturnHomeButton: View {
    @Environment(FlashcardsViewModel.self) var viewModel
    var onDismiss: () -> Void
    
    var body: some View {
      Button {
        onDismiss()
        viewModel.resetSetupSettings()
      } label: {
        Text("Return Home").padding(11)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
}

#Preview {
  FlashcardSummaryView.ReturnHomeButton {}
    .environment(FlashcardsViewModel.previewMode)
}

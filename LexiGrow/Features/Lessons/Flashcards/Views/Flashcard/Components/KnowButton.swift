//
//  KnowButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

//extension FlashcardView {
//  
//  struct KnowButton: View {
//    @Environment(FlashcardsViewModel.self) var viewModel
//    @Binding var isFlipped: Bool
//    
//    var body: some View {
//      Button {
//        viewModel.handleKnown()
//        isFlipped = false
//      } label: {
//        Label("Know", systemImage: "checkmark.seal.fill")
//          .padding(12)
//      }
//      .borderedButtonStyle(tint: .blue)
//    }
//  }
//}

#Preview {
  FlashcardView.KnowButton(isFlipped: .constant(true))
    .environment(FlashcardsViewModel.previewMode)
}

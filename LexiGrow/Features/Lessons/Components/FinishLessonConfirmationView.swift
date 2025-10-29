//
//  FinishLessonSheet.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FinishLessonConfirmationView: View {
  @Environment(\.dismiss) var dismiss
  var finishAction: () -> Void
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {
        Spacer()
        VStack(spacing: 12) {
          Text("Finish lesson?")
            .font(.title2)
            .fontWeight(.bold)
          Text("The progress will not be saved.")
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        }
        PrimaryButton("Finish", tint: .red) {
          finishAction()
        }
      }
      .padding(.horizontal)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          CloseButton {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  FinishLessonConfirmationView {}
}

//
//  FinishLessonSheet.swift
//  ReWord
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
          Text("Завершити урок?")
            .font(.title2)
            .fontWeight(.bold)
          Text("Ваш прогрес не буде збережено.")
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        }
        PrimaryButton("Завершити", tint: .red) {
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

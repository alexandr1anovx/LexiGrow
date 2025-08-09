//
//  FinishLessonSheet.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FinishLessonSheet: View {
  @Environment(\.dismiss) var dismiss
  var onDismiss: () -> Void
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {
        VStack(spacing: 15) {
          Text("All progress will be canceled")
            .font(.title2)
            .fontWeight(.bold)
          Text("Are you sure you want to finish the lesson?")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        }
        Button {
          onDismiss() // hides the lesson view
        } label: {
          Text("Yes, finish")
            .padding(11)
        }
        .prominentButtonStyle(tint: .red)
      }
      .toolbar {
        ToolbarItem(placement: .destructiveAction) {
          DismissXButton {
            dismiss() // dismiss the sheet
          }
        }
      }
    }
  }
}

#Preview {
  FinishLessonSheet {}
}

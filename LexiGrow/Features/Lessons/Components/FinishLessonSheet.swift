//
//  FinishLessonSheet.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FinishLessonSheet: View {
  @Environment(\.dismiss) var dismiss
  var finishAction: () -> Void
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {

        VStack(spacing: 15) {
          Text("All progress will be cancelled")
            .font(.title2)
            .fontWeight(.bold)
          Text("Are you sure you want to finish the lesson?")
            .font(.subheadline)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        }
        
        if #available (iOS 26, *) {
          Button(action: finishAction) {
            Text("Yes, finish")
              .padding(10)
              .frame(maxWidth: .infinity)
              .fontWeight(.medium)
          }
          .padding(.horizontal)
          .tint(.red)
          .buttonStyle(.glassProminent)
        } else {
          Button(action: finishAction) {
            Text("Yes, finish")
              .prominentLabelStyle(tint: .red)
          }
          .padding(.horizontal)
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          DismissXButton {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  FinishLessonSheet {}
}

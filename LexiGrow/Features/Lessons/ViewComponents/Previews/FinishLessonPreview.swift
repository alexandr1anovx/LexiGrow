//
//  FinishLessonSheet.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FinishLessonPreview: View {
  @Environment(\.dismiss) var dismiss
  var onDismiss: () -> Void
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      
      VStack(spacing: 30) {
        Spacer()
        ConfirmationText()
        FinishButton {
          onDismiss()
        }
      }.padding(.bottom)
    }
    .presentationDetents([.fraction(0.33)])
    .presentationCornerRadius(50)
    .overlay(alignment: .topTrailing) {
      DismissXButton {
        dismiss()
      }.padding(20)
    }
  }
}

private extension FinishLessonPreview {
  
  struct ConfirmationText: View {
    var body: some View {
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
    }
  }
  
  struct FinishButton: View {
    var action: () -> Void
    
    var body: some View {
      Button(action: action) {
        Text("Yes, finish")
          .padding(11)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
}

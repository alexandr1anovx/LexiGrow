//
//  FinishLessonSheet.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct ExitLessonView: View {
  private var dismissAction: () -> Void
  @Environment(\.dismiss) var dismiss
  
  init(_ dismissAction: @escaping () -> Void) {
    self.dismissAction = dismissAction
  }
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      VStack(spacing: 30) {
        Spacer()
        confirmationText
        finishButton
      }.padding(.bottom)
    }
    .presentationDetents([.fraction(0.3)])
    .presentationCornerRadius(50)
    .overlay(alignment: .topTrailing) {
      dismissButton
    }
  }
  
  private var confirmationText: some View {
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
  
  private var dismissButton: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.pink)
    }
    .padding([.top,.trailing], 20)
  }
  
  private var finishButton: some View {
    Button(action: dismissAction) {
      Text("Yes, finish")
        .foregroundStyle(.white)
        .fontWeight(.semibold)
        .padding(11)
    }
    .tint(.pink)
    .buttonBorderShape(.roundedRectangle(radius: 20))
    .buttonStyle(.borderedProminent)
  }
}

#Preview {
  ExitLessonView {}
}

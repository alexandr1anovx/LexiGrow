//
//  FinishLessonSheet.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct ExitLessonView: View {
  @Binding var isShowing: Bool
  private var dismissAction: () -> Void
  
  init(
    _ isShowing: Binding<Bool>,
    dismissAction: @escaping () -> Void
  ) {
    self._isShowing = isShowing
    self.dismissAction = dismissAction
  }
  
  var body: some View {
    VStack(spacing: 15) {
      Spacer()
      Text("Exit the lesson?")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundStyle(.white)
      Text("All progress will be canceled.")
        .font(.callout)
        .fontWeight(.medium)
        .foregroundStyle(.white.opacity(0.8))
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      Spacer()
      HStack {
        Button {
          isShowing = false
        } label: {
          Text("Cancel")
            .padding(11)
            .foregroundStyle(.white)
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(.bordered)
        Button(action: dismissAction) {
          Text("Exit")
            .padding(11)
            .foregroundStyle(.red)
            .fontWeight(.medium)
        }
        .tint(.white)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
      }.padding(.bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationBackground(
      LinearGradient(
        colors: [.red, .pink],
        startPoint: .leading,
        endPoint: .trailing
      )
    )
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
  }
}

#Preview {
  ExitLessonView(.constant(true), dismissAction: {})
}

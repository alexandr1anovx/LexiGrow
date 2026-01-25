//
//  EmailConfirmationScreen.swift
//  ReWord
//
//  Created by Alexander Andrianov on 17.09.2025.
//

import SwiftUI

struct EmailConfirmationView: View {
  @State private var showSendButton = false
  @State private var animateShadow = false
  @State private var remainingTime = 0
  let email: String
  var sendAction: (() -> Void)? = nil
  
  var body: some View {
    VStack(spacing: 30) {
      Text("Перевірте свою пошту 👀")
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundStyle(.secondary)
      VStack {
        Text("Ми надіслали посилання для підтвердження на адресу ") + Text(email).bold().foregroundStyle(.secondary)
      }
      .font(.subheadline)
      .multilineTextAlignment(.center)
      
      Button {
        sendAction?()
        disableButtonTemporarily()
      } label: {
        if remainingTime > 0 {
          Text("Send again in \(remainingTime)s")
        } else {
          Text("Send again")
            .foregroundStyle(.blue)
        }
      }
      .font(.subheadline)
      .underline()
      .disabled(!showSendButton)
    }
    .padding(.horizontal)
    .background {
      RoundedRectangle(cornerRadius: 50, style: .circular)
        .fill(.systemGray)
        .shadow(
          color: animateShadow ? .blue : .yellow,
          radius: 5,
          x: 0,
          y: animateShadow ? 2:-2
        )
        .frame(height: 240)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      disableButtonTemporarily()
      withAnimation(.linear(duration: 1).repeatForever()) {
        animateShadow.toggle()
      }
    }
  }
  
  private func disableButtonTemporarily() {
    showSendButton = false
    remainingTime = 60
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      if remainingTime > 0 {
        remainingTime -= 1
      } else {
        timer.invalidate()
        showSendButton = true
      }
    }
  }
}

#Preview {
  EmailConfirmationView(email: "an4lex@gmail.com")
}

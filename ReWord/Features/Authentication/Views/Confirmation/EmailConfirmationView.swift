//
//  EmailConfirmationScreen.swift
//  ReWord
//
//  Created by Alexander Andrianov on 17.09.2025.
//

import SwiftUI

struct EmailConfirmationView: View {
  @State private var showSendButton = false
  @State private var remainingTime = 0
  let email: String
  var sendAction: (() -> Void)? = nil
  
  @Environment(AuthManager.self) private var authManager
  
  var body: some View {
    VStack(spacing: 35) {
      Text("Check your email")
        .font(.title3)
        .fontWeight(.semibold)
      VStack {
        Text("A confirmation link has been sent to ") + Text(email).bold().foregroundStyle(.blue)
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
      .tint(.blue)
      .buttonStyle(.bordered)
      .font(.subheadline)
      .disabled(!showSendButton)
    }
    .padding(.horizontal, 20)
    .background {
      RoundedRectangle(cornerRadius: 40, style: .circular)
        .fill(.systemGray)
        
        .frame(height: 240)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      disableButtonTemporarily()
    }
    .task {
      while !Task.isCancelled {
        try? await Task.sleep(for: .seconds(3))
        await authManager.checkEmailConfirmation(email: email)
      }
    }
  }
  
  private func disableButtonTemporarily() {
    showSendButton = false
    remainingTime = 30
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
    .environment(AuthManager.mock)
}

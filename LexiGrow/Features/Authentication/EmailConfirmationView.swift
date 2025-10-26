//
//  EmailConfirmationScreen.swift
//  LexiGrow
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
    ZStack {
      Color.mainBackground.ignoresSafeArea()
      VStack(spacing: 30) {
        Text("Check your inbox")
          .font(.title2)
          .fontWeight(.semibold)
        VStack {
          Text("We have sent a confirmation link to")
            .foregroundStyle(.secondary)
          Text(email)
            .foregroundStyle(.primary)
            .fontWeight(.medium)
        }
        .font(.subheadline)
        .padding(.horizontal)
        
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
      .padding(.vertical, 40)
      .padding(.horizontal, 20)
      .background {
        RoundedRectangle(cornerRadius: 50)
          .fill(.systemGray)
          .shadow(
            color: animateShadow ? .yellow : .blue,
            radius: 3,
            x: 0,
            y: animateShadow ? 2:-2
          )
      }
      .navigationBarBackButtonHidden()
      .onAppear {
        disableButtonTemporarily()
        withAnimation(.linear(duration: 1).repeatForever()) {
          animateShadow.toggle()
        }
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

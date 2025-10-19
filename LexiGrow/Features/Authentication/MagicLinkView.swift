//
//  MagicLinkView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.10.2025.
//

import SwiftUI

struct MagicLinkView: View {
  @State private var email = ""
  @State private var isLinkSent = false
  
  var body: some View {
    ZStack {
      if isLinkSent {
        ConfirmationView(email: email)
      } else {
        FormView(email: $email, isLinkSent: $isLinkSent)
      }
    }.animation(.easeInOut, value: isLinkSent)
  }
}

extension MagicLinkView {
  struct FormView: View {
    @Environment(AuthManager.self) var authManager
    @Binding var email: String
    @Binding var isLinkSent: Bool
    private let validator = ValidationService.shared
    
    var body: some View {
      VStack(spacing: 25) {
        VStack(spacing: 20) {
          HStack(spacing: 8) {
            Image(systemName: "sparkles")
            Text("Magic Link")
              .fontWeight(.bold)
          }
          .font(.title2)
          Text("Enter your email address and we will send you a link for instant access.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, .defaultPadding)
        }
        
        DefaultTextField(
          title: "Email address",
          iconName: "at",
          text: $email
        )
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        
        PrimaryButton(title: "Send link") {
          Task {
            await authManager.signInWithMagicLink(for: email)
            isLinkSent = true
          }
        }
        .disabled(!validator.isValidEmail(email))
        .opacity(!validator.isValidEmail(email) ? 0.5:1)
        
        Spacer()
      }
      .padding(.horizontal, .defaultPadding)
    }
  }
  
  struct ConfirmationView: View {
    @Environment(AuthManager.self) var authManager
    @State private var animateSymbol = false
    let email: String
    
    var body: some View {
      VStack(spacing: 25) {
        
        Image(systemName: "checkmark.circle.fill")
          .symbolEffect(.bounce, value: animateSymbol)
          .font(.largeTitle)
        
        Text("We have sent a login link to **\(email)**.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
        
        HStack(spacing: 5) {
          Text("Didn't receive the letter?")
          Button {
            Task { await authManager.signInWithMagicLink(for: email) }
          } label: {
            Text("Send again")
              .fontWeight(.medium)
              .underline()
              .foregroundStyle(.blue)
          }
        }.font(.subheadline)
      }
      .padding(.horizontal, .defaultPadding)
      .onAppear { animateSymbol = true }
      // Do not allow the user to return to the login screen.
      .navigationBarBackButtonHidden()
    }
  }
}

#Preview {
  MagicLinkView.ConfirmationView(email: "an4lex@gmail.com")
    .environment(AuthManager.mockObject)
}

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
    }
    .padding()
    .animation(.easeInOut, value: isLinkSent)
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
            .padding(.horizontal)
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
      }
    }
  }
  
  struct ConfirmationView: View {
    @Environment(AuthManager.self) var authManager
    let email: String
    
    var body: some View {
      VStack(spacing: 25) {
        Text("Done!")
          .font(.title3)
          .fontWeight(.semibold)
        Text("We have sent a login link to **\(email)**.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
        HStack(spacing: 10) {
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
      .padding(30)
      .background {
        RoundedRectangle(cornerRadius: 30)
          .fill(Color(.systemGray6))
          .shadow(radius: 3)
      }
    }
  }
}

#Preview {
  MagicLinkView()
    .environment(AuthManager.mockObject)
}

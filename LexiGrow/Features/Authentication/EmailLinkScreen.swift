//
//  MagicLinkView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.10.2025.
//

import SwiftUI

struct EmailLinkScreen: View {
  @Environment(AuthManager.self) var authManager
  @State private var email = ""
  @State private var showConfirmationView = false
  
  var body: some View {
    if showConfirmationView {
      EmailConfirmationView(email: email) { // send action:
        Task {
          await authManager.signInWithMagicLink(for: email)
        }
      }
    } else {
      FormView(email: $email, showConfirmationView: $showConfirmationView)
    }
  }
}

extension EmailLinkScreen {
  struct FormView: View {
    @Environment(AuthManager.self) var authManager
    @Binding var email: String
    @Binding var showConfirmationView: Bool
    @FocusState private var fieldContent: Field?
    private let validator = ValidationService.shared
    
    var body: some View {
      VStack(spacing: 25) {
        VStack(spacing: 20) {
          HStack(spacing: 8) {
            Image(systemName: "envelope.fill")
            Text("Email Link")
              .fontWeight(.bold)
          }
          .font(.title2)
          Text("Enter your email address and we will send you a link for instant access.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        
        DefaultTextField(content: .email, text: $email)
          .focused($fieldContent, equals: .email)
          .keyboardType(.emailAddress)
          .textInputAutocapitalization(.never)
          .submitLabel(.done)
          .onSubmit { fieldContent = nil }
        
        PrimaryButton("Send link") {
          Task {
            await authManager.signInWithMagicLink(for: email)
          }
          withAnimation(.easeInOut(duration: 0.6)) {
            showConfirmationView = true
          }
        }
        .disabled(!validator.isValidEmail(email))
        .opacity(!validator.isValidEmail(email) ? 0.5:1)
        
        Spacer()
      }
      .padding(.horizontal)
      .background(.mainBackground)
      .onAppear { fieldContent = .email }
    }
  }
}

#Preview {
  EmailLinkScreen()
    .environment(AuthManager.mock)
}

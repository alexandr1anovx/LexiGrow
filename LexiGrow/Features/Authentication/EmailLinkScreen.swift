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
    ZStack {
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
            Text("Вхід через посилання")
              .fontWeight(.bold)
          }
          .font(.title2)
          Text("Введіть свою адресу електронної пошти, і Вам буде надіслано посилання для миттєвого входу.")
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
        
        PrimaryButton("Відправити посилання") {
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
      .onAppear { fieldContent = .email }
    }
  }
}

#Preview {
  EmailLinkScreen()
    .environment(AuthManager.mock)
}

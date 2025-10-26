//
//  PasswordResetView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct ForgotPasswordScreen: View {
  @Environment(\.dismiss) var dismiss
  @Environment(AuthManager.self) var authManager
  
  @State private var email = ""
  @State private var isLoading = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  @FocusState private var fieldContent: Field?
  private let validator = ValidationService.shared
  
  var body: some View {
    VStack(spacing: 25) {
      
      VStack(spacing: 25) {
        Label("Forgot password", systemImage: "lock.circle.fill")
          .font(.title2)
          .fontWeight(.bold)
        Text("Enter your email address to receive a link to reset your password.")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
      }
      
      DefaultTextField(content: .email, text: $email)
        .focused($fieldContent, equals: .email)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .submitLabel(.done)
        .onSubmit { fieldContent = nil }
      
      PrimaryButton("Send link") {
        Task {
          await authManager.requestPasswordReset(for: email)
          email = ""
          dismiss()
        }
      }
      .disabled(!validator.isValidEmail(email) || isLoading)
      .opacity(!validator.isValidEmail(email) ? 0.5 : 1)
      
      Spacer()
    }
    .padding([.top, .horizontal])
    .background(.mainBackground)
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text(alertTitle),
        message: Text(alertMessage),
        dismissButton: .default(Text("OK"))
      )
    }
    .onAppear { fieldContent = .email }
  }
}

#Preview {
  ForgotPasswordScreen()
    .environment(AuthManager.mock)
}

//
//  PasswordResetView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(AuthManager.self) var authManager
  
  @State private var email = ""
  @State private var isLoading = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  @FocusState private var fieldContent: TextFieldContent?
  private let validator = ValidationService.shared
  
  var body: some View {
    VStack(spacing: 25) {
      VStack(spacing: 25) {
        HStack(spacing: 8) {
          Image(systemName: "lock.circle.fill")
          Text("Forgot Password")
            .fontWeight(.bold)
        }
        .font(.title2)
        Text("Enter your email address to receive a link to reset your password.")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 10)
      }
      
      DefaultTextField(
        title: "Email address",
        iconName: "at",
        text: $email
      )
      .focused($fieldContent, equals: .email)
      .submitLabel(.done)
      .onSubmit {
        fieldContent = nil
      }
      .keyboardType(.emailAddress)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled(true)
      
      PrimaryButton(title: "Submit") {
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
    .padding()
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
  ForgotPasswordView()
    .environment(AuthManager.mockObject)
}

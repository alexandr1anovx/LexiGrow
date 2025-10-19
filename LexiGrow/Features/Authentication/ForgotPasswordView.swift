//
//  PasswordResetView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
  @Environment(AuthManager.self) var authManager
  @Environment(\.dismiss) var dismiss
  
  @State private var email = ""
  @State private var isLoading = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  private let validator = ValidationService.shared
  
  @FocusState private var fieldContent: TextFieldContent?
  
  var body: some View {
    VStack(spacing: 25) {
      
      VStack(spacing: 25) {
        Image(systemName: "lock.circle.fill")
          .font(.system(size: 35))
        Text("Enter your email address to receive a link to reset your password.")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal,10)
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

//
//  PasswordResetView.swift
//  ReWord
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
        Text("Забули пароль?")
          .font(.title2)
          .fontWeight(.bold)
        Text("Введіть свою адресу електронної пошти, щоб отримати посилання для скидання пароля.")
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
      
      PrimaryButton("Надіслати посилання") {
        Task {
          await authManager.requestPasswordReset(for: email)
          email = ""
          dismiss()
        }
      }
      .disabled(!validator.isValidEmail(email) || isLoading)
      
      Spacer()
    }
    .padding([.top, .horizontal])
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

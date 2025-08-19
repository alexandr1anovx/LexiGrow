//
//  PasswordResetView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct PasswordResetView: View {
  @Environment(AuthManager.self) var authManager
  @Environment(\.dismiss) var dismiss
  
  @State private var email = ""
  @State private var isLoading = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  var body: some View {
    VStack(spacing: 20) {
      VStack(spacing: 15) {
        Image(systemName: "lock.circle.fill")
          .font(.system(size: 40))
        Text("Reset Password")
          .font(.title)
          .fontWeight(.semibold)
        Text("Enter your email address and we'll send you a link to get back into your account.")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
      .padding(.bottom, 15)
      
      DefaultTextField(
        title: "Email address",
        iconName: "at",
        text: $email
      )
      .keyboardType(.emailAddress)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled(true)
      
      Button {
        authManager.requestPasswordReset(for: email)
        email = ""
        dismiss()
      } label: {
        Text("Send Reset Link")
          .prominentButtonStyle(tint: .pink)
      }
      .disabled(!isEmailValid() || isLoading)
      .opacity(!isEmailValid() ? 0.5 : 1)
      
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
  }
  
  // MARK: - Methods
  
  /// Checks if the entered email has a valid format.
  /// - Returns: A boolean indicating if the email is valid.
  private func isEmailValid() -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: email)
  }
  
  /// Handles the password reset logic.
  private func resetPassword() async {
    guard isEmailValid() else {
      alertTitle = "Invalid Email"
      alertMessage = "Please enter a valid email address."
      showAlert = true
      return
    }
    
    isLoading = true
    defer { isLoading = false }
    
    do {
      // try await supabase.auth.resetPasswordForEmail(email)
      
      // Simulating a network request for demonstration purposes.
      try await Task.sleep(nanoseconds: 2_000_000_000)
      
      alertTitle = "Check Your Email"
      alertMessage = "A password reset link has been sent to \(email)."
      showAlert = true
    } catch {
      alertTitle = "Error"
      alertMessage = error.localizedDescription
      showAlert = true
    }
  }
}
// MARK: - Preview

#Preview {
  PasswordResetView()
}

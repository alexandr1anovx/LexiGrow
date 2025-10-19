//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct RegistrationScreen: View {
  @Environment(\.dismiss) var dismiss
  @Environment(AuthManager.self) var authManager
  @State private var fullName = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  
  private let validator = ValidationService.shared
  private var isValidForm: Bool {
    validator.isValidFullName(fullName) &&
    validator.isValidEmail(email) &&
    validator.isValidPassword(password) &&
    password == confirmPassword
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 25) {
          InputFields(
            fullName: $fullName,
            email: $email,
            password: $password,
            confirmPassword: $confirmPassword
          )
          
          PrimaryButton(title: "Sign Up") {
            Task {
              await authManager.signUp(
                fullName: fullName,
                email: email,
                password: password
              )
              password = ""
              confirmPassword = ""
            }
          }
          .disabled(!isValidForm)
          .opacity(!isValidForm ? 0.5:1)
          
          HStack(spacing: 5) {
            Text("Already have an account?")
              .foregroundStyle(.secondary)
            Button("Sign In") {
              dismiss()
            }
            .tint(.primary)
            .underline()
          }
          .font(.subheadline)
        }
        .padding(.horizontal, .defaultPadding)
        .padding(.top)
        .opacity(authManager.isLoading ? 0.5:1)
        .disabled(authManager.isLoading)
        .overlay {
          if authManager.isLoading {
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.systemGray)
              .frame(width: 60, height: 60)
              .overlay {
                ProgressView()
              }
          }
        }
        .navigationTitle("Registration")
        .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}

extension RegistrationScreen {
  
  struct InputFields: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @FocusState private var inputContent: TextFieldContent?
    
    var body: some View {
      VStack(spacing: 10) {
        DefaultTextField(
          title: "First name and last name",
          iconName: "person",
          text: $fullName
        )
        .focused($inputContent, equals: .fullName)
        .textInputAutocapitalization(.words)
        .autocorrectionDisabled(true)
        .submitLabel(.next)
        .onSubmit { inputContent = .email }
        DefaultTextField(
          title: "Email",
          iconName: "at",
          text: $email
        )
        .focused($inputContent, equals: .email)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
        .submitLabel(.next)
        .onSubmit { inputContent = .password }
        SecureTextField(
          title: "Password",
          iconName: "lock",
          text: $password,
          showToggleIcon: true
        )
        .focused($inputContent, equals: .password)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .submitLabel(.next)
        .onSubmit { inputContent = .confirmPassword }
        SecureTextField(
          title: "Confirm password",
          iconName: "lock",
          text: $confirmPassword,
          showToggleIcon: false
        )
        .focused($inputContent, equals: .confirmPassword)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .submitLabel(.done)
        .onSubmit { inputContent = nil }
      }
    }
  }
}

#Preview {
  RegistrationScreen()
    .environment(AuthManager.mockObject)
}

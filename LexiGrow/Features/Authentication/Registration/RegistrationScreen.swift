//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct RegistrationScreen: View {
  @Environment(AuthManager.self) var authManager
  @State private var username = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  
  var body: some View {
    ScrollView {
      VStack(spacing: 30) {
        TypingTextEffect(text: "Registration in LexiGrow.")
        InputFields(
          username: $username,
          email: $email,
          password: $password,
          confirmPassword: $confirmPassword
        )
        if let error = authManager.signUpError {
          Text(error)
            .font(.footnote)
            .foregroundStyle(.red)
            .fontWeight(.medium)
            .padding(.horizontal)
        }
        if authManager.isLoading {
          GradientRingProgressView()
        } else {
          SignUpButton(
            username: $username,
            email: $email,
            password: $password,
            confirmPassword: $confirmPassword
          )
        }
        SignInOption()
      }
      .padding(.top)
    }
  }
}

extension RegistrationScreen {
  
  struct InputFields: View {
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @FocusState private var inputContent: InputFieldContent?
    
    var body: some View {
      VStack(spacing: 10) {
        InputField(.standard, "Username", text: $username)
          .focused($inputContent, equals: .username)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .submitLabel(.next)
          .onSubmit { inputContent = .email }
        InputField(.standard, "Email", text: $email)
          .focused($inputContent, equals: .email)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .keyboardType(.emailAddress)
          .submitLabel(.next)
          .onSubmit { inputContent = .password }
        InputField(.password, "Password", text: $password)
          .focused($inputContent, equals: .password)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .submitLabel(.next)
          .onSubmit { inputContent = .confirmPassword }
        InputField(
          .passwordConfirmation,
          "Confirm Password",
          text: $confirmPassword,
          isMatchPassword: password == confirmPassword
        )
        .focused($inputContent, equals: .confirmPassword)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .submitLabel(.done)
        .onSubmit { inputContent = nil }
      }
      .font(.subheadline)
      .padding(.horizontal, 25)
    }
  }
  
  struct SignUpButton: View {
    @Environment(AuthManager.self) var authManager
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    private var isValidForm: Bool {
      !username.isEmpty &&
      !email.isEmpty &&
      !password.isEmpty && password == confirmPassword
    }
    var body: some View {
      Button {
        Task {
          await authManager.signUp(
            username: username,
            email: email,
            password: password
          )
          password = ""
          confirmPassword = ""
        }
      } label: {
        Text("Sign Up")
          .padding(.horizontal,120)
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(!isValidForm)
    }
  }
  
  struct SignInOption: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
      HStack {
        Text("Already have an account?")
          .font(.footnote)
          .foregroundStyle(.secondary)
        Button {
          dismiss()
        } label: {
          Text("Sign In.")
            .font(.subheadline)
            .underline()
        }.tint(.primary)
      }
    }
  }
}

#Preview {
  RegistrationScreen()
    .environment(AuthManager.mock)
}

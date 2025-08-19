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
        Text("Registration in LexiGrow")
          .font(.title2)
          .fontWeight(.bold)
          .fontDesign(.rounded)
          .foregroundStyle(
            LinearGradient(
              colors: [.purple, .pink, .pink],
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .padding(.top)
        
        InputFields(
          username: $username,
          email: $email,
          password: $password,
          confirmPassword: $confirmPassword
        )
        .padding(.horizontal, 15)
        
        if authManager.isLoading {
          GradientProgressView()
        } else {
          SignUpButton(
            username: $username,
            email: $email,
            password: $password,
            confirmPassword: $confirmPassword
          )
          .padding(.horizontal, 15)
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
    @FocusState private var inputContent: TextFieldContent?
    
    var body: some View {
      VStack(spacing: 10) {
        DefaultTextField(
          title: "Username",
          iconName: "person",
          text: $username
        )
        .focused($inputContent, equals: .username)
        .textInputAutocapitalization(.never)
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
          .prominentButtonStyle(tint: .pink)
      }
      .disabled(!isValidForm)
      .opacity(!isValidForm ? 0.5 : 1)
    }
  }
  
  struct SignInOption: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
      HStack(spacing: 5) {
        Text("Already have an account?")
          .foregroundStyle(.secondary)
        Button {
          dismiss()
        } label: {
          Text("Sign In.")
            .underline()
        }.tint(.primary)
      }
      .font(.footnote)
    }
  }
}

#Preview {
  RegistrationScreen()
    .environment(AuthManager.mockObject)
}

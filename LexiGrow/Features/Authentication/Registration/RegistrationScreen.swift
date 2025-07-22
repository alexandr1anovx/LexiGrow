//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct RegistrationScreen: View {
  
  @State var viewModel: RegistrationViewModel
  @Environment(AuthManager.self) private var authManager
  @FocusState private var inputContent: InputFieldContent?
  @Environment(\.dismiss) var dismiss
  
  init(authManager: AuthManager) {
    _viewModel = State(wrappedValue: RegistrationViewModel(authManager: authManager))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 30) {
        title
        inputFields
        signUpButton
        signInOption
      }.padding(.top)
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    TypingTextEffect(text: "Registration in LexiGrow.")
  }
  
  private var inputFields: some View {
    VStack(spacing: 10) {
      InputField(.standard, "Username", text: $viewModel.username)
        .focused($inputContent, equals: .username)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .submitLabel(.next)
        .onSubmit {
          inputContent = .email
        }
      InputField(.standard, "Email", text: $viewModel.email)
        .focused($inputContent, equals: .email)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
        .submitLabel(.next)
        .onSubmit {
          inputContent = .password
        }
      InputField(.password, "Password", text: $viewModel.password)
        .focused($inputContent, equals: .password)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .submitLabel(.next)
        .onSubmit {
          inputContent = .confirmPassword
        }
      InputField(
        .passwordConfirmation,
        "Confirm Password",
        text: $viewModel.confirmedPassword,
        isMatchPassword: viewModel.password == viewModel.confirmedPassword
      )
      .focused($inputContent, equals: .confirmPassword)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled(true)
      .submitLabel(.done)
      .onSubmit {
        inputContent = nil
      }
    }
    .font(.subheadline)
    .padding(.horizontal, 25)
  }
  
  private var signUpButton: some View {
    Button {
      viewModel.signUp()
    } label: {
      Group {
        if authManager.isLoading {
          HStack {
            ProgressView()
            Text("Registration ...")
          }
        } else {
          Text("Sign Up")
        }
      }
    }
    .padding(.horizontal, 30)
    .disabled(!viewModel.isValidForm)
    .opacity(!viewModel.isValidForm ? 0.5 : 1)
  }
  
  private var signInOption: some View {
    HStack {
      Text("Already have an account?")
        .font(.footnote)
        .foregroundStyle(.secondary)
      Button {
        dismiss()
      } label: {
        Text("Sign In.")
          .fontWeight(.medium)
          .font(.subheadline)
          .underline()
      }.tint(.primary)
    }
  }
}

#Preview {
  RegistrationScreen(authManager: AuthManager())
    .environment(AuthManager())
}

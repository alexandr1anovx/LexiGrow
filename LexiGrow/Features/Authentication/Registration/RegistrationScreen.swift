//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct RegistrationScreen: View {
  @State var viewModel: RegistrationViewModel
  
  init(authManager: AuthManager) {
    _viewModel = State(wrappedValue: RegistrationViewModel(authManager: authManager))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 30) {
        TypingTextEffect(text: "Registration in LexiGrow.")
        InputFields(viewModel: viewModel)
        SignUpButton(viewModel: viewModel)
        SignInOption()
      }
      .padding(.top)
    }
  }
}

extension RegistrationScreen {
  
  // MARK: - Input Fields
  struct InputFields: View {
    @Bindable var viewModel: RegistrationViewModel
    @FocusState private var inputContent: InputFieldContent?
    var body: some View {
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
  }
  
  // MARK: - Sign Up button
  struct SignUpButton: View {
    @Environment(AuthManager.self) var authManager
    @Bindable var viewModel: RegistrationViewModel
    var body: some View {
      Button {
        viewModel.signUp()
      } label: {
        Text("Sign Up")
          .padding(.horizontal,120)
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(!viewModel.isValidForm)
    }
  }
  
  // MARK: - Sign In option
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
            .fontWeight(.medium)
            .font(.subheadline)
            .underline()
        }.tint(.primary)
      }
    }
  }
  
}

#Preview {
  RegistrationScreen(authManager: AuthManager())
    .environment(AuthManager())
}

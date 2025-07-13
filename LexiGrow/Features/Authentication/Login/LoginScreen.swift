//
//  LoginScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct LoginScreen: View {
  @State var viewModel: LoginViewModel
  @Environment(AuthManager.self) private var authManager
  @FocusState private var inputContent: InputFieldContent?
  
  init(authManager: AuthManager) {
    _viewModel = State(wrappedValue: LoginViewModel(authManager: authManager))
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing:30) {
          title
          inputFields
          signInButton
          signUpOption
        }.padding(.top)
      }
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    TypingTextEffect(text: "Login. Welcome to LexiGrow.")
  }
  
  private var inputFields: some View {
    VStack(spacing:12) {
      InputField(.standard, "Email", text: $viewModel.email)
        .focused($inputContent, equals: .email)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
        .submitLabel(.next)
        .onSubmit { inputContent = .password }
      InputField(.password, "Password", text: $viewModel.password)
        .focused($inputContent, equals: .email)
        .submitLabel(.done)
        .onSubmit { inputContent = nil }
    }
    .padding(.horizontal,25)
  }
  
  private var signInButton: some View {
    Button {
      viewModel.signIn()
    } label: {
      Group {
        if authManager.isLoading {
          HStack {
            ProgressView()
            Text("Checking ...")
          }
        } else {
          Text("Sign In")
        }
      }
    }
    .linearGradientButtonStyle()
    .padding(.horizontal,30)
    .disabled(!viewModel.isValidForm)
    .opacity(!viewModel.isValidForm ? 0.5:1)
  }
  
  private var signUpOption: some View {
    HStack {
      Text("Don't have have an account?")
        .font(.footnote)
        .foregroundStyle(.secondary)
      NavigationLink {
        RegistrationScreen(authManager: authManager)
      } label: {
        Text("Sign Up.")
          .font(.subheadline)
          .fontWeight(.medium)
          .underline()
      }
      .tint(.primary)
    }
  }
}

#Preview {
  LoginScreen(authManager: AuthManager())
    .environment(AuthManager())
}

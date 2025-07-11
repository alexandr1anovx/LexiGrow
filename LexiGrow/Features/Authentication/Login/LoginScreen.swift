//
//  LoginScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct LoginScreen: View {
  
  @Environment(AuthManager.self) private var authManager
  @FocusState private var inputContent: InputFieldContent?
  @State var viewModel: LoginViewModel
  
  init(authManager: AuthManager) {
    _viewModel = State(wrappedValue: LoginViewModel(authManager: authManager))
  }
  
  var body: some View {
    NavigationStack {
      VStack(spacing:30) {
        title
        inputFields
        signInButton
        signUpOption
      }.padding(.top)
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    TypingEffectView(text: "Login. Welcome to LexiGrow.")
  }
  
  private var inputFields: some View {
    VStack(spacing:12) {
      TextField("Email", text: $viewModel.email)
        .focused($inputContent, equals: .email)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
        .customInputFieldStyle() // repeats
        .submitLabel(.next)
        .onSubmit {
          inputContent = .password
        }
      SecureField("Password", text: $viewModel.password)
        .focused($inputContent, equals: .email)
        .customInputFieldStyle()
        .submitLabel(.done)
        .onSubmit {
          inputContent = nil
        }
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
          .font(.callout)
          .fontWeight(.medium)
          .fontDesign(.monospaced)
          .foregroundStyle(.white)
          .padding(.vertical,16)
          .padding(.horizontal,95)
          .background(Color.gradientOrangePink)
          .clipShape(.rect(cornerRadius:15))
        } else {
          Text("Sign In")
            .font(.callout)
            .fontWeight(.medium)
            .fontDesign(.monospaced)
            .foregroundStyle(.white)
            .padding(.vertical,16)
            .padding(.horizontal,135)
            .background(Color.gradientOrangePink)
            .clipShape(.rect(cornerRadius:15))
        }
      }
      .shadow(radius: 5)
      .disabled(!viewModel.isValidForm)
      .opacity(!viewModel.isValidForm ? 0.5 : 1.0)
    }
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

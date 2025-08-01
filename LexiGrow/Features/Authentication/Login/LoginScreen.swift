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
        VStack(spacing: 30) {
          TypingTextEffect(text: "Login. Welcome to LexiGrow.")
          InputFields(viewModel: viewModel)
          Group {
            if authManager.isLoading {
              GradientRingProgressView()
            } else {
              SignInButton(viewModel: viewModel)
            }
          }
          SignUpOption()
        }
        .padding(.top,30)
      }
    }
  }
}

#Preview {
  LoginScreen(authManager: AuthManager())
    .environment(AuthManager())
    .environment(LoginViewModel(authManager: AuthManager()))
}


extension LoginScreen {
  
  struct InputFields: View {
    @Bindable var viewModel: LoginViewModel
    @FocusState private var inputContent: InputFieldContent?
    
    var body: some View {
      VStack(spacing: 12) {
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
      .padding(.horizontal, 25)
    }
  }
  
  struct SignInButton: View {
    @Environment(AuthManager.self) var authManager
    @Bindable var viewModel: LoginViewModel
    
    var body: some View {
      Button {
        viewModel.signIn()
      } label: {
        Text("Sign In")
          .padding(.horizontal,120)
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(!viewModel.isValidForm)
    }
  }
  
  struct SignUpOption: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
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
}

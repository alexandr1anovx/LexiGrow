//
//  LoginScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct LoginScreen: View {
  @State var viewModel = LoginViewModel()
  
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
    VStack(spacing:15) {
      TextField("Email", text: $viewModel.email)
        .customInputFieldStyle()
      SecureField("Password", text: $viewModel.password)
        .customInputFieldStyle()
    }
    .padding(.horizontal)
  }
  
  private var signInButton: some View {
    Button {
      viewModel.signIn()
    } label: {
      Text("Sign In")
        .font(.callout)
        .fontWeight(.medium)
        .foregroundStyle(.background)
        .padding(.vertical,18)
        .padding(.horizontal,140)
        .background(.primary)
        .clipShape(.rect(cornerRadius:14))
    }
    .disabled(!viewModel.isValidForm)
    .opacity(!viewModel.isValidForm ? 0.5 : 1.0)
  }
  
  private var signUpOption: some View {
    HStack {
      Text("Don't have have an account?")
        .font(.footnote)
        .foregroundStyle(.secondary)
      NavigationLink {
        RegistrationScreen()
      } label: {
        Text("Sign Up")
          .font(.subheadline)
          .fontWeight(.medium)
          .underline()
      }
      .tint(.primary)
    }
  }
}

#Preview {
  LoginScreen()
}

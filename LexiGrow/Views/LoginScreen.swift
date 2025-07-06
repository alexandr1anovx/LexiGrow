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
      VStack(spacing: 30) {
        Text("Login")
          .font(.title)
          .fontWeight(.semibold)
        
        VStack(spacing: 15) {
          TextField("Email", text: $viewModel.email)
            .customInputFieldStyle()
          SecureField("Password", text: $viewModel.password)
            .customInputFieldStyle()
        }.padding(.horizontal)
        
        Button {
          viewModel.signIn()
        } label: {
          Text("Sign In")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.vertical)
            .padding(.horizontal, 160)
            .background(.green)
            .clipShape(.rect(cornerRadius: 15))
        }
        .disabled(!viewModel.isValidForm)
        .opacity(!viewModel.isValidForm ? 0.5 : 1)
        
        HStack {
          Text("Don't have have an account?")
            .font(.footnote)
            .foregroundStyle(.secondary)
          NavigationLink {
            RegistrationScreen()
          } label: {
            Text("Sign Up")
          }
          .fontWeight(.medium)
          .font(.subheadline)
          .foregroundStyle(.green)
        }
      }
    }
  }
}

#Preview {
  LoginScreen()
}

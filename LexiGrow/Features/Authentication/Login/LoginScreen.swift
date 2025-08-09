//
//  LoginScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct LoginScreen: View {
  @Environment(AuthManager.self) private var authManager
  @State private var email: String = ""
  @State private var password: String = ""
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 30) {
          TypingTextEffect(text: "Login. Welcome to LexiGrow.")
          InputFields(email: $email, password: $password)
          if let error = authManager.signInError {
            Text(error)
              .font(.footnote)
              .foregroundStyle(.red)
              .fontWeight(.medium)
              .padding(.horizontal)
          }
          Group {
            if authManager.isLoading {
              GradientRingProgressView()
            } else {
              SignInButton(email: $email, password: $password)
            }
          }
          SignUpOption()
        }.padding(.top,30)
      }
    }
  }
}

extension LoginScreen {
  
  struct InputFields: View {
    @Binding var email: String
    @Binding var password: String
    @Environment(AuthManager.self) private var authManager
    @FocusState private var inputContent: InputFieldContent?
    
    var body: some View {
      VStack {
        InputField(.standard, "Email", text: $email)
          .focused($inputContent, equals: .email)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .keyboardType(.emailAddress)
          .submitLabel(.next)
          .onSubmit { inputContent = .password }
        InputField(.password, "Password", text: $password)
          .focused($inputContent, equals: .password)
          .submitLabel(.done)
          .onSubmit { inputContent = nil }
      }
      .padding(.horizontal, 25)
    }
  }
  
  struct SignInButton: View {
    @Environment(AuthManager.self) var authManager
    @Binding var email: String
    @Binding var password: String
    private var isValidForm: Bool {
      !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
      Button {
        Task {
          await authManager.signIn(email: email, password: password)
        }
        password = ""
      } label: {
        Text("Sign In")
          .padding(.horizontal,120)
          .padding(12)
      }
      .prominentButtonStyle(tint: .blue)
      .disabled(!isValidForm)
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
          RegistrationScreen()
        } label: {
          Text("Sign Up.")
            .font(.subheadline)
            .underline()
        }
        .tint(.primary)
      }
    }
  }
}

#Preview {
  LoginScreen()
    .environment(AuthManager.mock)
}

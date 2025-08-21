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
      VStack(spacing: 25) {
        Text("Welcome to LexiGrow")
          .font(.title2)
          .fontWeight(.bold)
          .padding(.bottom)
          .fontDesign(.rounded)
          .foregroundStyle(
            LinearGradient(
              colors: [.purple, .pink, .pink],
              startPoint: .leading,
              endPoint: .trailing
            )
          )
        InputFields(email: $email, password: $password)
        SignInButton(email: $email, password: $password)
        HStack {
          ForgotPasswordOption()
          Spacer()
          SignUpOption()
        }.padding(.horizontal, 20)
      }.padding(.top,30)
    }
  }
}

extension LoginScreen {
  
  struct InputFields: View {
    @Binding var email: String
    @Binding var password: String
    @FocusState private var inputContent: TextFieldContent?
    
    var body: some View {
      VStack {
        DefaultTextField(
          title: "Email address",
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
          showToggleIcon: false
        )
        .focused($inputContent, equals: .password)
        .submitLabel(.done)
        .onSubmit { inputContent = nil }
      }
      .padding(.horizontal, 15)
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
          password = ""
        }
      } label: {
        Group {
          if authManager.isLoading {
            CustomProgressView(tint: .white)
          } else {
            Text("Sign In")
          }
        }
        .prominentButtonStyle(tint: .pink)
      }
      .padding(.horizontal, 15)
      .opacity(!isValidForm ? 0.5 : 1)
      .disabled(!isValidForm)
    }
  }
  
  struct SignUpOption: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
      HStack(spacing: 5) {
        Text("New user?")
          .foregroundStyle(.secondary)
        NavigationLink {
          RegistrationScreen()
        } label: {
          Text("Sign Up")
            .underline(true)
        }
      }.font(.footnote)
    }
  }
  
  struct ForgotPasswordOption: View {
    @Environment(AuthManager.self) var authManager
    var body: some View {
      NavigationLink {
        PasswordResetView()
      } label: {
        Text("Forgot password?")
          .font(.footnote)
          .foregroundStyle(.secondary)
          .underline(true)
      }
    }
  }
}

#Preview {
  LoginScreen()
    .environment(AuthManager.mockObject)
}

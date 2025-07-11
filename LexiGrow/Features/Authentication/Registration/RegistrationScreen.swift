//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

enum InputFieldContent {
  case username
  case email
  case password
  case confirmPassword
}

struct RegistrationScreen: View {
  
  @State var viewModel: RegistrationViewModel
  @Environment(AuthManager.self) private var authManager
  @Environment(\.dismiss) var dismiss
  
  @State private var isShownPassword: Bool = false
  @FocusState private var inputContent: InputFieldContent?
  
  init(authManager: AuthManager) {
    _viewModel = State(wrappedValue: RegistrationViewModel(authManager: authManager))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing:30) {
        title
        inputFields
        signUpButton
        signInOption
      }.padding(.top)
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    TypingEffectView(text: "Registration in LexiGrow.")
  }
  
  private var inputFields: some View {
    VStack(spacing:12) {
      TextField("Username", text: $viewModel.username)
        .focused($inputContent, equals: .username)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .customInputFieldStyle() // repeats
        .submitLabel(.next)
        .onSubmit {
          inputContent = .email
        }
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
      
      Group {
        if isShownPassword {
          HStack {
            TextField("Password", text: $viewModel.password)
            Button {
              isShownPassword.toggle()
            } label: {
              Image(systemName: "eye.slash")
            }
            .opacity(viewModel.password.count > 1 ? 1 : 0)
          }
        } else {
          HStack {
            SecureField("Password", text: $viewModel.password)
            Button {
              isShownPassword.toggle()
            } label: {
              Image(systemName: "eye")
            }
            .opacity(viewModel.password.count > 1 ? 1 : 0)
          }
        }
      }
      .focused($inputContent, equals: .password)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled(true)
      .customInputFieldStyle() // repeats
      .submitLabel(.next)
      .onSubmit {
        inputContent = .confirmPassword
      }
        
      HStack {
        SecureField("Confirm Password", text: $viewModel.confirmedPassword)
        Button {
          isShownPassword.toggle()
        } label: {
          Image(systemName: viewModel.password == viewModel.confirmedPassword ? "checkmark.seal.fill" : "xmark.seal.fill")
            .foregroundStyle(viewModel.password == viewModel.confirmedPassword ? .green : .red)
            .opacity(viewModel.confirmedPassword.count > 1 ? 1 : 0)
        }
      }
      .focused($inputContent, equals: .confirmPassword)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled(true)
      .customInputFieldStyle() // repeats
      .submitLabel(.done)
      .onSubmit {
        inputContent = nil
      }
    }
    .font(.subheadline)
    .padding(.horizontal,25)
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
          .font(.callout)
          .fontWeight(.medium)
          .fontDesign(.monospaced)
          .foregroundStyle(.white)
          .padding(.vertical,16)
          .padding(.horizontal,80)
          .background(Color.gradientOrangePink)
          .clipShape(.rect(cornerRadius:15))
        } else {
          Text("Sign Up")
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
      .disabled(!viewModel.isValidForm)
      .opacity(!viewModel.isValidForm ? 0.5 : 1)
    }
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

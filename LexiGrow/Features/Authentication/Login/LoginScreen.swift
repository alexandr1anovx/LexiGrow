//
//  LoginScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct LoginScreen: View {
  @Bindable var authManager: AuthManager
  @State private var email = ""
  @State private var password = ""
  private var isValidForm: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color.mainBackground.ignoresSafeArea()
        ScrollView {
          VStack(spacing: 20) {
            TextFields(email: $email, password: $password)
            
            PrimaryButton("Sign In") {
              Task {
                await authManager.signIn(email: email, password: password)
                password = ""
              }
            }
            .opacity(!isValidForm ? 0.5:1)
            .disabled(!isValidForm)
            
            ORDivider()
            
            ScrollView(.horizontal) {
              HStack(spacing: 10) {
                GoogleButton()
                EmailLinkButton()
                PhoneNumberButton()
              }
            }
            .scrollIndicators(.hidden)
            
            FooterView()
          }
          .padding([.top, .horizontal])
          .opacity(authManager.isLoading ? 0.5 : 1)
          .disabled(authManager.isLoading)
          .overlay {
            if authManager.isLoading {
              DefaultProgressView()
            }
          }
          .navigationTitle("Sign In")
          .navigationBarTitleDisplayMode(.large)
          .alert(item: $authManager.authError) { error in
            Alert(
              title: Text(error.title),
              message: Text(error.message),
              dismissButton: .default(Text("OK"))
            )
          }
        }
      }
    }
  }
}


extension LoginScreen {
  
  // MARK: - Text Fields
  
  struct TextFields: View {
    @Binding var email: String
    @Binding var password: String
    @FocusState private var focusedField: Field?
    
    var body: some View {
      VStack {
        DefaultTextField(content: .email, text: $email)
          .focused($focusedField, equals: .email)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .keyboardType(.emailAddress)
          .submitLabel(.next)
          .onSubmit { focusedField = .password }
        
        SecureTextField(content: .password, text: $password, showEye: false)
          .focused($focusedField, equals: .password)
          .submitLabel(.done)
          .onSubmit { focusedField = nil }
      }
    }
  }
  
  // MARK: - OR Divider
  
  struct ORDivider: View {
    var body: some View {
      HStack {
        VStack { Divider() }
        Text("OR WITH")
          .font(.footnote)
          .foregroundStyle(.secondary)
        VStack { Divider() }
      }
    }
  }
  
  // MARK: - Buttons
  
  struct GoogleButton: View {
    @Environment(AuthManager.self) var authManager
    var body: some View {
      Button {
        Task { await authManager.signInWithGoogle() }
      } label: {
        Label {
          Text("Google")
        } icon: {
          Image(.googleIcon)
            .resizable()
            .frame(width: 22, height: 22)
        }
        .capsuleLabelStyle(withShadow: false)
      }
    }
  }
  struct EmailLinkButton: View {
    var body: some View {
      NavigationLink {
        EmailLinkScreen()
      } label: {
        Label("Link", systemImage: "envelope.fill")
          .capsuleLabelStyle(withShadow: false)
      }
    }
  }
  struct PhoneNumberButton: View {
    var body: some View {
      NavigationLink {
        PhoneNumberView()
      } label: {
        Label("Phone", systemImage: "phone.fill")
          .capsuleLabelStyle(withShadow: false)
      }
      .disabled(true)
      .opacity(0.5)
    }
  }
  
  // MARK: - Footer View
  
  struct FooterView: View {
    var body: some View {
      HStack {
        NavigationLink {
          ForgotPasswordScreen()
        } label: {
          Text("Forgot password?")
            .underline()
        }
        Spacer()
        HStack(spacing: 5) {
          Text("New user?")
          NavigationLink {
            RegistrationScreen()
          } label: {
            Text("Sign Up")
              .foregroundStyle(.primary)
              .underline()
          }
        }
      }
      .font(.subheadline)
      .foregroundStyle(.secondary)
      .padding(.top, 8)
    }
  }
}

#Preview {
  LoginScreen(authManager: AuthManager.mock)
    .environment(AuthManager.mock)
}

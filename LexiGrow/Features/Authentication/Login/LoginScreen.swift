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
            
            PrimaryButton("Увійти") {
              Task {
                await authManager.signIn(email: email, password: password)
                password = ""
              }
            }
            .opacity(!isValidForm ? 0.5:1)
            .disabled(!isValidForm)
            
            HStack {
              Text("Увійти через:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
              
              ScrollView(.horizontal) {
                HStack(spacing: 10) {
                  GoogleButton()
                  EmailLinkButton()
                  PhoneNumberButton()
                }
              }
              .scrollIndicators(.hidden)
            }
            .padding(.vertical)
            
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
          .navigationTitle("Вхід")
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
            .frame(width: 20, height: 20)
        }
        .capsuleLabelStyle(pouring: .systemGray, withShadow: false)
      }
    }
  }
  struct EmailLinkButton: View {
    var body: some View {
      NavigationLink {
        EmailLinkScreen()
      } label: {
        Label("Посилання", systemImage: "envelope.fill")
          .capsuleLabelStyle(pouring: .systemGray, withShadow: false)
      }
    }
  }
  struct PhoneNumberButton: View {
    var body: some View {
      NavigationLink {
        PhoneNumberView()
      } label: {
        Label("Номер телефону", systemImage: "phone.fill")
          .capsuleLabelStyle(pouring: .systemGray, withShadow: false)
      }
      .disabled(true)
      .opacity(0.8)
    }
  }
  
  // MARK: - Footer View
  
  struct FooterView: View {
    var body: some View {
      HStack(spacing: 20) {
        NavigationLink {
          ForgotPasswordScreen()
        } label: {
          Text("Забули пароль?")
            .underline()
        }
        Spacer()
        VStack(spacing: 5) {
          Text("Новий користувач?")
          NavigationLink {
            RegistrationScreen()
          } label: {
            Text("Зареєструватись.")
              .foregroundStyle(.primary)
              .underline()
          }
        }
      }
      .font(.footnote)
      .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  LoginScreen(authManager: AuthManager.mock)
    .environment(AuthManager.mock)
}

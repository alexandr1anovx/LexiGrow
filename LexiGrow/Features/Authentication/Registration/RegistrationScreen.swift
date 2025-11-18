//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct RegistrationScreen: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AuthManager.self) private var authManager
  @State private var fullName = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  
  private let validator = ValidationService.shared
  private var isValidForm: Bool {
    validator.isValidFullName(fullName) &&
    validator.isValidEmail(email) &&
    validator.isValidPassword(password) &&
    password == confirmPassword
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 25) {
          TextFields(
            fullName: $fullName,
            email: $email,
            password: $password,
            confirmPassword: $confirmPassword
          )
          
          PrimaryButton("Зареєструватись") {
            Task {
              await authManager.signUp(
                fullName: fullName,
                email: email,
                password: password
              )
              password = ""
              confirmPassword = ""
            }
          }
          .disabled(!isValidForm)
          .opacity(!isValidForm ? 0.5:1)
          
          HStack(spacing: 5) {
            Text("Вже маєте обліковий запис?")
              .foregroundStyle(.secondary)
            Button("Увійти.") {
              dismiss()
            }
            .underline()
          }
          .font(.subheadline)
        }
        .padding([.top, .horizontal])
        .opacity(authManager.isLoading ? 0.5 : 1)
        .disabled(authManager.isLoading)
        .overlay {
          if authManager.isLoading {
            DefaultProgressView()
          }
        }
      }
      .navigationTitle("Реєстрація")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

extension RegistrationScreen {
  
  struct TextFields: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @FocusState private var focusedField: Field?
    
    var body: some View {
      VStack(spacing: 10) {
        DefaultTextField(content: .fullName, text: $fullName)
          .focused($focusedField, equals: .fullName)
          .textInputAutocapitalization(.words)
          .submitLabel(.next)
          .onSubmit { focusedField = .email }
        
        DefaultTextField(content: .email, text: $email)
          .focused($focusedField, equals: .email)
          .keyboardType(.emailAddress)
          .submitLabel(.next)
          .onSubmit { focusedField = .password }
        
        SecureTextField(content: .password, text: $password, showEye: true)
          .focused($focusedField, equals: .password)
          .submitLabel(.next)
          .onSubmit { focusedField = .confirmPassword }
        
        SecureTextField(content: .confirmPassword, text: $confirmPassword, showEye: false)
          .focused($focusedField, equals: .confirmPassword)
          .submitLabel(.done)
          .onSubmit { focusedField = nil }
      }
      .autocorrectionDisabled()
    }
  }
}

#Preview {
  RegistrationScreen()
    .environment(AuthManager.mock)
}

//
//  LoginScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct LoginScreen: View {
  //@Environment(AuthManager.self) private var authManager
  @Bindable var authManager: AuthManager
  @State private var email = ""
  @State private var password = ""
  private var isValidForm: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          InputFields(email: $email, password: $password)
          
          PrimaryButton(title: "Sign In") {
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
              MagicLinkButton()
              PhoneNumberButton()
            }
          }.scrollIndicators(.hidden)
          
          FooterView()
        }
        .opacity(authManager.isLoading ? 0.5:1)
        .disabled(authManager.isLoading)
        .overlay {
          if authManager.isLoading {
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.systemGray)
              .frame(width: 60, height: 60)
              .overlay { ProgressView() }
          }
        }
        .padding([.top, .horizontal], .defaultPadding)
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


extension LoginScreen {
  
  // MARK: - Input Fields
  
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
        .capsuleLabelStyle()
      }
    }
  }
  struct MagicLinkButton: View {
    var body: some View {
      NavigationLink {
        MagicLinkView()
      } label: {
        Label("Magic Link", systemImage: "sparkles")
          .capsuleLabelStyle()
      }
    }
  }
  struct PhoneNumberButton: View {
    var body: some View {
      NavigationLink {
        PhoneNumberInputView()
      } label: {
        Label("Phone Number", systemImage: "phone.fill")
          .capsuleLabelStyle()
      }
    }
  }
  
  // MARK: - Footer View
  
  struct FooterView: View {
    var body: some View {
      HStack {
        NavigationLink {
          ForgotPasswordView()
        } label: {
          Text("Forgot password?")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .underline()
        }
        Spacer()
        HStack(spacing: 5) {
          Text("New user?")
            .foregroundStyle(.secondary)
          NavigationLink {
            RegistrationScreen()
          } label: {
            Text("Sign Up")
              .underline()
          }
        }.font(.subheadline)
      }.padding(.top, 8)
    }
  }
}

#Preview {
  LoginScreen(authManager: AuthManager.mockObject)
    .environment(AuthManager.mockObject)
}

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
        Spacer()
        TypingEffectView()
      }.padding(.top)
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    Text("Login")
      .font(.title2)
      .fontWeight(.semibold)
      .fontDesign(.monospaced)
  }
  
  private var inputFields: some View {
    VStack(spacing:15) {
      TextField("Email", text: $viewModel.email)
        .customInputFieldStyle()
      SecureField("Password", text: $viewModel.password)
        .customInputFieldStyle()
    }
    .fontDesign(.monospaced)
    .padding(.horizontal)
  }
  
  private var signInButton: some View {
    Button {
      viewModel.signIn()
    } label: {
      Text("Sign In")
        .font(.callout)
        .fontWeight(.medium)
        .fontDesign(.monospaced)
        .foregroundStyle(.white)
        .padding(.vertical)
        .padding(.horizontal,150)
        .background(.indigo)
        .clipShape(.rect(cornerRadius:15))
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


struct TypingEffectView: View {
  
  let fullText = "Welcome to LexiGrow."
  @State private var displayedText = ""
  @State private var isDeleting = false
  @State private var timer: Timer?
  @State private var typingTextOpacity = 0.0
  
  var body: some View {
    
    HStack(spacing: 0) {
        Text(displayedText)
          .font(.footnote)
          .fontWeight(.medium)
          .fontDesign(.monospaced)
          .underline()
        Rectangle() // Cursor
          .frame(width: 2, height: 20)
      }
      .onAppear {
        startAnimation()
      }
      .onDisappear {
        timer?.invalidate()
      }
      .foregroundStyle(displayedText == fullText ? .indigo : .gray)
      .opacity(typingTextOpacity)
  }
  
  private func startAnimation() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
      if isDeleting {
        if !displayedText.isEmpty {
          displayedText.removeLast()
          typingTextOpacity -= 0.1
        } else {
          isDeleting = false
        }
      } else {
        if displayedText.count < fullText.count {
          let index = fullText.index(fullText.startIndex, offsetBy: displayedText.count)
          displayedText.append(fullText[index])
          typingTextOpacity += 0.1
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isDeleting = true
          }
        }
      }
    }
  }
}

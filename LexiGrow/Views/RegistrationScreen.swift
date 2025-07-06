//
//  RegistrationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct RegistrationScreen: View {
  @State var viewModel = RegistrationViewModel()
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      // Add a background color in the future.
      ScrollView {
        VStack(spacing:30) {
          title
          inputFields
          signUpButton
          signInOption
        }.padding(.top)
      }
    }
  }
  
  // MARK: - Subviews
  
  private var title: some View {
    Text("Registration")
      .font(.title2)
      .fontWeight(.semibold)
      .fontDesign(.monospaced)
  }
  
  private var inputFields: some View {
    VStack(spacing:15) {
      TextField("Full Name", text: $viewModel.fullName)
        .customInputFieldStyle()
      TextField("Email", text: $viewModel.email)
        .customInputFieldStyle()
      SecureField("Password", text: $viewModel.password)
        .customInputFieldStyle()
      SecureField("Confirm Password", text: $viewModel.confirmedPassword)
        .customInputFieldStyle()
    }
    .fontDesign(.monospaced)
    .padding(.horizontal)
  }
  
  private var signUpButton: some View {
    Button {
      viewModel.signUp()
    } label: {
      Text("Sign Up")
        .font(.callout)
        .fontWeight(.medium)
        .fontDesign(.monospaced)
        .foregroundStyle(.white)
        .padding(.vertical)
        .padding(.horizontal,160)
        .background(.indigo)
        .clipShape(.rect(cornerRadius:15))
    }
    .disabled(!viewModel.isValidForm)
    .opacity(!viewModel.isValidForm ? 0.5 : 1)
  }
  
  private var signInOption: some View {
    HStack {
      Text("Already have an account?")
        .font(.footnote)
        .foregroundStyle(.secondary)
      Button {
        dismiss()
      } label: {
        Text("Sign In")
          .fontWeight(.medium)
          .font(.subheadline)
          .underline()
      }.tint(.primary)
    }
  }
}

#Preview {
  RegistrationScreen()
}

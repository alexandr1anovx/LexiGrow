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
      // Add a background color here.
      ScrollView {
        VStack(spacing: 30) {
          
          Text("Registration")
            .font(.title)
            .fontWeight(.semibold)
          
          VStack(spacing: 15) {
            TextField("Full Name", text: $viewModel.fullName)
              .customInputFieldStyle()
            TextField("Email", text: $viewModel.email)
              .customInputFieldStyle()
            SecureField("Password", text: $viewModel.password)
              .customInputFieldStyle()
            SecureField("Confirm Password", text: $viewModel.confirmedPassword)
              .customInputFieldStyle()
          }.padding(.horizontal)
          
          Button {
            viewModel.signUp()
          } label: {
            Text("Sign Up")
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
            Text("Already have an account?")
              .font(.footnote)
              .foregroundStyle(.secondary)
            Button("Sign In") {
              dismiss()
            }
            .fontWeight(.medium)
            .font(.subheadline)
            .foregroundStyle(.green)
          }
        }.padding(.top)
      }
    }
  }
}

#Preview {
  RegistrationScreen()
}

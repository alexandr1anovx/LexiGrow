//
//  InputField.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 10.07.2025.
//

import SwiftUI

enum InputFieldContent {
  case username
  case email
  case password
  case confirmPassword
}

enum InputFieldType {
  case standard
  case password
  case passwordConfirmation
}

struct InputField: View {
  let type: InputFieldType
  let placeholder: String
  @Binding private var text: String
  var isMatchPassword: Bool = false
  @State private var isShownPassword: Bool = false
  
  init(
    _ type: InputFieldType,
    _ placeholder: String,
    text: Binding<String>,
    isMatchPassword: Bool = false
  ) {
    self.type = type
    self.placeholder = placeholder
    self._text = text
    self.isMatchPassword = isMatchPassword
  }
  
  var body: some View {
    Group {
      switch type {
      case .standard: standardInputField
      case .password: passwordInputField
      case .passwordConfirmation: passwordConfirmationInputField
      }
    }.inputFieldStyle()
  }
  
  var standardInputField: some View {
    TextField(placeholder, text: $text)
  }
  
  @ViewBuilder
  var passwordInputField: some View {
      HStack {
        if isShownPassword {
          TextField(placeholder, text: $text)
        } else {
          SecureField(placeholder, text: $text)
        }
        Button {
          isShownPassword.toggle()
        } label: {
          Image(systemName: isShownPassword ? "eye" : "eye.slash")
        }
        .opacity(text.isEmpty ? 0:1)
        .disabled(text.isEmpty)
      }
  }
  
  @ViewBuilder
  var passwordConfirmationInputField: some View {
    HStack {
      SecureField("Confirm Password", text: $text)
      Image(systemName: isMatchPassword ? "checkmark" : "xmark")
        .foregroundStyle(isMatchPassword ? .green : .red)
        .opacity(text.isEmpty ? 0:1)
    }
  }
}

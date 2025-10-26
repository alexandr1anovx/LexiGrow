//
//  SecureTextField.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct SecureTextField: View {
  let content: Field
  @Binding var text: String
  @State private var showPassword = false
  var showEye = true
  
  var body: some View {
    HStack {
      Image(systemName: content.iconName)
        .foregroundColor(.secondary)
        .padding(.leading)
        .frame(minWidth: 35)
      
      if showPassword {
        TextField(content.title, text: $text)
      } else {
        SecureField(content.title, text: $text)
      }
      
      if showEye && !text.isEmpty {
        Image(systemName: showPassword ? "eye" : "eye.slash")
          .onTapGesture {
            showPassword.toggle()
          }
          .padding(.trailing)
      }
    }
    .frame(height: 55)
    .background {
      Capsule()
        .fill(.thinMaterial)
        .shadow(radius: 1)
    }
  }
}

#Preview {
  @Previewable @State var password = "123456"
  VStack {
    SecureTextField(content: .password, text: $password)
    SecureTextField(content: .confirmPassword, text: $password, showEye: false)
  }
}

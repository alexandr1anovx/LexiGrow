//
//  SecureTextField.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct SecureTextField: View {
  let title: String
  let iconName: String
  @Binding var text: String
  @State private var showPassword = false
  var showToggleIcon: Bool = true
  
  var body: some View {
    HStack {
      Image(systemName: iconName)
        .foregroundColor(.secondary)
        .padding(.leading)
        .frame(minWidth: 35)
      
      if showPassword {
        TextField(title, text: $text)
      } else {
        SecureField(title, text: $text)
      }
      
      if showToggleIcon && !text.isEmpty {
        Image(systemName: showPassword ? "eye" : "eye.slash")
          .onTapGesture {
            showPassword.toggle()
          }
          .padding(.trailing)
      }
    }
    .frame(height: 55)
    .background(.thinMaterial)
    .clipShape(.rect(cornerRadius: 20))
  }
}

#Preview {
  @Previewable @State var password = "123456"
  VStack {
    SecureTextField(
      title: "Password",
      iconName: "lock",
      text: $password
    )
    SecureTextField(
      title: "Password",
      iconName: "lock",
      text: $password,
      showToggleIcon: false
    )
  }
}

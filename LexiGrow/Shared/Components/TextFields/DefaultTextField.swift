//
//  DefaultTextField.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.08.2025.
//

import SwiftUI

struct DefaultTextField: View {
  let content: Field
  @Binding var text: String
  
  var body: some View {
    HStack {
      Image(systemName: content.iconName)
        .foregroundColor(.secondary)
        .padding(.leading)
      TextField(content.title, text: $text)
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
  @Previewable @State var email = "andr1anov@gmail.com"
  DefaultTextField(content: .email, text: $email)
}

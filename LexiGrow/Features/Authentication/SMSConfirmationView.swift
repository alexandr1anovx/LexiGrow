//
//  SMSConfirmationView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.10.2025.
//

import SwiftUI
import Combine

struct PhoneNumberInputView: View {
  @State private var phoneNumber = ""
  @FocusState private var fieldContent: TextFieldContent?
  private let validator = ValidationService.shared
  
  var body: some View {
    VStack(spacing: 20) {
      
      VStack(spacing: 15) {
        Image(systemName: "phone.fill")
          .font(.system(size: 30))
        Text("Enter your phone number to receive a confirmation SMS.")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, .defaultPadding)
      }
      
      DefaultTextField(
        title: "+380(50) 123 45 67",
        iconName: "phone.fill",
        text: $phoneNumber
      )
      .focused($fieldContent, equals: .email)
      .submitLabel(.done)
      .onSubmit { fieldContent = nil }
      .keyboardType(.emailAddress)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled(true)
      .padding(.top)
      
      Button {
        // action
      } label: {
        Text("Send code")
          .prominentLabelStyle(tint: .blue)
      }
      .disabled(!validator.isValidUkrainianPhoneNumber(phoneNumber))
      .opacity(!validator.isValidUkrainianPhoneNumber(phoneNumber) ? 0.5 : 1)
      
      Spacer()
    }
    .padding(.horizontal, .defaultPadding)
  }
}

struct SMSConfirmationView: View {
  
  let phoneNumber: String
  @State private var code: [String] = Array(repeating: "", count: 6)
  @FocusState private var focusedField: Int?
  
  var body: some View {
    VStack(spacing: 20) {
      VStack(spacing: 15) {
        Image(systemName: "message.circle.fill")
          .font(.system(size: 40))
        Text("Enter the code")
          .font(.title.bold())
        Text("We have sent a 6-digit confirmation code to **\(phoneNumber)**.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
      
      HStack(spacing: 10) {
        ForEach(0..<6, id: \.self) { index in
          TextField("", text: $code[index])
            .keyboardType(.numberPad)
            .frame(width: 45, height: 55)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .multilineTextAlignment(.center)
            .font(.title2.bold())
            .focused($focusedField, equals: index)
            .tag(index)
            .onChange(of: code[index]) {
              if code[index].count == 1 && index < 5 {
                focusedField = index + 1
              }
              if code[index].isEmpty && index > 0 {
                focusedField = index - 1
              }
              if index == 5 && !code[5].isEmpty {
                verifyCode()
              }
            }
        }
      }
      .onReceive(Just(code)) { _ in
        // Дозволяє вставити скопійований код
        if code.joined().count == 6 {
          verifyCode()
        }
      }
      
      Button("Send code again") {
        // action
      }
      .tint(.blue)
      .underline()
      .padding(.top, 20)
      
      Spacer()
    }
    .padding()
    .onAppear { focusedField = 0 }
  }
  
  private func verifyCode() {
    focusedField = nil
    let finalCode = code.joined()
    print("Перевіряємо код: \(finalCode)")
    // метод для перевірки коду
    // await authManager.verifySmsCode(finalCode)
  }
}

#Preview {
  SMSConfirmationView(phoneNumber: "+380 (99) 123 45 67")
//  PhoneNumberInputView()
}

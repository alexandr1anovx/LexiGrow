//
//  SMSConfirmationView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.10.2025.
//

import SwiftUI

struct PhoneNumberView: View {
  @Environment(AuthManager.self) private var authManager
  @State private var showConfirmationView = false
  @State private var phoneNumber = ""
  @FocusState private var fieldContent: Field?
  private let validator = ValidationService.shared
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        VStack(spacing: 20) {
          Image(systemName: "phone.fill")
            .font(.system(size: 30))
          Text("Введіть свій номер телефону, щоб отримати код з SMS.")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        
        DefaultTextField(content: .phoneNumber, text: $phoneNumber)
          .focused($fieldContent, equals: .email)
          .submitLabel(.done)
          .onSubmit { fieldContent = nil }
          .keyboardType(.emailAddress)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .padding(.top)
        
        PrimaryButton("Надіслати код") {
          Task {
            if await authManager.sendOTP(for: phoneNumber) {
              showConfirmationView = true
            }
          }
        }
        .disabled(!validator.isValidUkrainianPhoneNumber(phoneNumber))
        
        Spacer()
      }
      .padding(.horizontal)
      .navigationDestination(isPresented: $showConfirmationView) {
        SMSConfirmationView(phoneNumber: phoneNumber)
      }
    }
  }
}

struct SMSConfirmationView: View {
  @Environment(AuthManager.self) private var authManager
  @FocusState private var isKeyboardFocused: Bool
  @State private var otpCode = ""
  let phoneNumber: String
  
  var body: some View {
    VStack(spacing: 20) {
      
      VStack(spacing: 12) {
        Text("Введіть код")
          .font(.title)
          .fontWeight(.bold)
        Text("Ми надіслали 6-значний код підтвердження на **\(phoneNumber)**.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding()
      }
      
      ZStack {
        HStack(spacing: 10) {
          ForEach(0..<6) { index in
            OTPBox(
              character: character(at: index),
              isActive: index == otpCode.count
            )
          }
        }
        TextField("", text: $otpCode)
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .focused($isKeyboardFocused)
          .opacity(0)
          .onChange(of: otpCode) {
            limitOTPCodeLength()
            autoSubmitWhenReady()
          }
      }
      .onTapGesture { isKeyboardFocused = true }
      
      PrimaryButton("Надіслати код знову") {
        // action
      }
      .padding(.top, 20)
      
      Spacer()
    }
    .padding()
    .onAppear { isKeyboardFocused = true }
  }
  
  // MARK: - Private Helper Methods
  
  /// Возвращает символ из строки `otpCode` по индексу.
  private func character(at index: Int) -> String {
    guard index < otpCode.count else { return "" }
    let startIndex = otpCode.startIndex
    let charIndex = otpCode.index(startIndex, offsetBy: index)
    return String(otpCode[charIndex])
  }
  
  private func limitOTPCodeLength() {
    if otpCode.count > 6 {
      otpCode = String(otpCode.prefix(6))
    }
  }
  
  private func autoSubmitWhenReady() {
    if otpCode.count == 6 {
      isKeyboardFocused = false
      Task {
        await authManager.verifyOTP(for: phoneNumber, with: otpCode)
      }
    }
  }
}

// MARK: - OTPBox

private struct OTPBox: View {
  let character: String
  let isActive: Bool
  
  var body: some View {
    Text(character)
      .font(.title)
      .fontWeight(.bold)
      .frame(width: 45, height: 55)
      .background(.thinMaterial, in: Capsule())
      .overlay {
        if isActive {
          Capsule()
            .stroke(.mainGreen, lineWidth: 2)
        }
      }
  }
}

#Preview {
  NavigationStack {
    //PhoneNumberView()
    SMSConfirmationView(phoneNumber: "+380 (99) 123 45 67")
  }
  .environment(AuthManager.mock)
}

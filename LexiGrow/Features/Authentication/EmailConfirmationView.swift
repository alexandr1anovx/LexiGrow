//
//  EmailConfirmationScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.09.2025.
//

import SwiftUI

struct EmailConfirmationView: View {
  @Environment(AuthManager.self) var authManager
  @State private var showAlert = false
  @State private var animateIcon = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  var body: some View {
    VStack(spacing: 25) {
      VStack(spacing: 20) {
        Text("Check your inbox")
          .font(.title3)
          .fontWeight(.semibold)
        Text("We have sent a confirmation link to your email address. Please check your inbox.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
      
      Button {
        alertTitle = "Letter sent"
        alertMessage = "We have resent the confirmation letter to your email address."
        showAlert = true
      } label: {
        Text("Send again")
          .capsuleLabelStyle(pouring: .primary)
          .foregroundStyle(Color.system)
      }
    }
    .padding(.vertical,30)
    .padding(.horizontal)
    .background {
      RoundedRectangle(cornerRadius: 30)
        .fill(.thinMaterial)
        .shadow(radius: 2)
    }
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text(alertTitle),
        message: Text(alertMessage),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}

#Preview {
  EmailConfirmationView()
    .environment(AuthManager.mockObject)
}

//
//  SignOutView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct SignOutConfirmationView: View {
  @Environment(AuthManager.self) var authManager
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      VStack(spacing: 30) {
        Spacer()
        VStack(spacing: 15) {
          Text("Sign Out")
            .font(.title2)
            .fontWeight(.bold)
          Text("Are you sure you want to sign out ?")
            .foregroundStyle(.secondary)
        }
        PrimaryButton("Sign Out", tint: .pink) {
          Task {
            await authManager.signOut()
            dismiss()
          }
        }
        .disabled(authManager.isLoading)
        .opacity(authManager.isLoading ? 0.5 : 1)
        .padding(.horizontal)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          CloseButton {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  SignOutConfirmationView()
    .environment(AuthManager.mock)
}

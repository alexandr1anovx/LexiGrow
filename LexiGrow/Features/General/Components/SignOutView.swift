//
//  SignOutView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension GeneralTabScreen {
  
  struct SignOutView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
      NavigationView {
        VStack(spacing: 30) {
          Spacer()
          VStack(spacing: 10) {
            Text("Sign Out")
              .font(.title2)
              .fontWeight(.bold)
            Text("Are you sure you want to sign out?")
              .font(.callout)
              .foregroundStyle(.secondary)
          }
          if authManager.isLoading {
            GradientProgressView(tint: .pink)
          } else {
            Button {
              Task {
                await authManager.signOut()
              }
            } label: {
              Text("Confirm")
                .prominentButtonStyle(tint: .red)
            }
            .padding([.horizontal, .bottom], 15)
          }
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            DismissXButton {
              dismiss()
            }
          }
        }
      }
    }
  }
}

#Preview {
  GeneralTabScreen.SignOutView()
    .environment(AuthManager.mockObject)
}

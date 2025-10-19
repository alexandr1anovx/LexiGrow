//
//  SignOutView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension MoreScreen {
  
  struct SignOutView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
      NavigationView {
        VStack(spacing: 30) {
          
          VStack(spacing: 10) {
            Text("Sign Out")
              .font(.title2)
              .fontWeight(.bold)
            Text("Are you sure you want to sign out?")
              .font(.callout)
              .foregroundStyle(.secondary)
          }
          
          if #available(iOS 26, *) {
            Button {
              Task {
                await authManager.signOut()
                dismiss()
              }
            } label: {
              Group {
                if authManager.isLoading {
                  CustomProgressView(tint: .white)
                } else {
                  Text("Yes, sign out")
                }
              }
              .modernLabelStyle(textColor: .white)
            }
            .tint(.red)
            .buttonStyle(.glassProminent)
            .padding(.horizontal, 20)
          } else {
            Button {
              Task { await authManager.signOut() }
            } label: {
              Group {
                if authManager.isLoading {
                  CustomProgressView(tint: .white)
                } else {
                  Text("Yes, sign out")
                }
              }
              .prominentLabelStyle(tint: .red)
            }
            .padding(.horizontal, 20)
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
  MoreScreen.SignOutView()
    .environment(AuthManager.mockObject)
}

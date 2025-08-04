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
          VStack(spacing: 10) {
            Text("Sign Out")
              .font(.title2)
              .fontWeight(.bold)
            Text("Are you sure you want to sign out?")
              .font(.callout)
              .foregroundStyle(.secondary)
          }
          Group {
            if authManager.isLoading {
              GradientRingProgressView(tint: .red)
            } else {
              Button {
                Task { await authManager.signOut() }
              } label: {
                Text("Yes, sign out.")
                  .padding(12)
              }.prominentButtonStyle(tint: .red)
            }
          }
        }
        .presentationDetents([.fraction(0.35)])
        .presentationCornerRadius(50)
        .toolbar {
          ToolbarItem(placement: .destructiveAction) {
            DismissXButton {
              dismiss()
            }.padding(.top)
          }
        }
      }
    }
  }
}

#Preview {
  GeneralTabScreen.SignOutView()
    .environment(AuthManager())
}

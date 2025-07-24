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
    @Binding var isShowingSignOutView: Bool
    
    var body: some View {
      VStack {
        HStack {
          Spacer()
          DismissXButton {
            isShowingSignOutView = false
          }
        }.padding(.trailing)
        
        VStack(spacing: 10) {
          Text("Sign Out")
            .font(.title2)
            .fontWeight(.bold)
          Text("Are you sure you want to sign out?")
            .font(.callout)
            .foregroundStyle(.secondary)
        }
        
        Button {
          Task {
            await authManager.signOut()
          }
        } label: {
          HStack {
            if authManager.isLoading {
              ProgressView()
                .tint(.white)
            }
            Text(authManager.isLoading ? "Signing out..." : "Yes, sign out")
              .fontWeight(.semibold)
              .padding(12)
          }
        }
        .padding(.top,20)
        .prominentButtonStyle(tint: .pink)
      }
      .presentationDetents([.fraction(0.3)])
      .presentationCornerRadius(50)
    }
  }
}

#Preview {
  GeneralTabScreen.SignOutView(
    isShowingSignOutView: .constant(true)
  )
  .environment(AuthManager())
}

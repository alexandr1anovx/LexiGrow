//
//  GeneralScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 11.07.2025.
//

import SwiftUI

struct GeneralTabScreen: View {
  @Environment(AuthManager.self) private var authManager
  @State private var isShowingSignOutView: Bool = false
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.mainBackgroundColor.ignoresSafeArea()
        
        Form {
          // User Data section
          Section {
            UserDataView()
          } footer: {
            HStack(spacing: 5) {
              Text("Would you like to edit your data?")
              NavigationLink {
                ProfileScreen(authManager: authManager)
              } label: {
                Text("Go to Profile.")
                  .font(.footnote)
                  .fontWeight(.medium)
                  .underline()
              }
            }
          }
          // Sign Out section
          Section {
            Button("Sign Out") {
              isShowingSignOutView = true
            }.tint(.red)
          }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("General")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isShowingSignOutView) {
          SignOutView(isShowingSignOutView: $isShowingSignOutView)
        }
      }
    }
  }
}

#Preview {
  GeneralTabScreen().environment(AuthManager())
}

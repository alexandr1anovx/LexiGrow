//
//  GeneralScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 11.07.2025.
//

import SwiftUI

struct MoreScreen: View {
  @Environment(AuthManager.self) var authManager
  @State private var showSignOutConfirmation = false
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color.mainBackground.ignoresSafeArea()
        Form {
          Section {
            if let user = authManager.currentUser {
              UserDataView(user: user)
            } else {
              Text("No data provided")
            }
          } header: {
            Text("Personal data")
          } footer: {
            HStack(spacing: 5) {
              Text("Would you like to edit your data?")
              NavigationLink {
                ProfileScreen()
              } label: {
                Text("Go to Profile")
                  .underline()
              }
            }.font(.footnote)
          }
          
          Section {
            NavigationLink("Settings") {
              SettingsScreen()
            }
          }
          
          Section {
            Button("Sign Out") {
              showSignOutConfirmation = true
            }.tint(.red)
          }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("More")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showSignOutConfirmation) {
          SignOutConfirmationView()
            .presentationDetents([.fraction(0.35)])
        }
        .overlay {
          if authManager.isLoading {
            DefaultProgressView()
          }
        }
      }
    }
  }
}

#Preview {
  MoreScreen()
    .environment(AuthManager.mock)
}

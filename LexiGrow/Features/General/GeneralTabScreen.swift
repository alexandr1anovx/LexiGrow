//
//  GeneralScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 11.07.2025.
//

import SwiftUI

struct GeneralTabScreen: View {
  @Environment(AuthManager.self) private var authManager
  @Environment(\.colorScheme) var colorScheme
  @State private var showSignOutSheet = false
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          UserDataView()
        } footer: {
          HStack(spacing: 5) {
            Text("Would you like to edit your data?")
            NavigationLink {
              ProfileScreen()
            } label: {
              Text("Go to Profile.")
                .font(.footnote)
                .underline()
            }
          }
        }
        NavigationLink("Settings") {
          SettingsScreen()
        }
        Section {
          Button("Sign Out") {
            showSignOutSheet = true
          }.tint(.red)
        }
      }
      .navigationTitle("General")
      .navigationBarTitleDisplayMode(.large)
      .sheet(isPresented: $showSignOutSheet) {
        SignOutView()
          .presentationDetents([.fraction(0.35)])
          .presentationCornerRadius(50)
      }
    }
  }
}

#Preview {
  GeneralTabScreen()
    .environment(AuthManager.mockObject)
}

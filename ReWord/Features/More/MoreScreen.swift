//
//  GeneralScreen.swift
//  ReWord
//
//  Created by Alexander Andrianov on 11.07.2025.
//

import SwiftUI

struct MoreScreen: View {
  @Environment(AuthManager.self) var authManager
  @State private var showSignOutConfirmation = false
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          if let user = authManager.currentUser {
            UserDataView(user: user)
          } else {
            Text("Дані не надано")
          }
        } footer: {
          HStack(spacing: 5) {
            Text("Хочеш редагувати свої дані?")
            NavigationLink {
              ProfileScreen()
            } label: {
              Text("Перейти до профілю")
                .underline()
            }
          }.font(.footnote)
        }
        
        Section {
          NavigationLink {
            SettingsScreen()
          } label: {
            Label {
              Text("Налаштування")
            } icon: {
              Image(systemName: "gearshape")
                .font(.subheadline)
            }
          }
        }
        
        Section {
          Button("Вийти") {
            showSignOutConfirmation = true
          }.tint(.red)
        }
      }
      .navigationTitle(Tab.more.rawValue)
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

#Preview {
  MoreScreen()
    .environment(AuthManager.mock)
}

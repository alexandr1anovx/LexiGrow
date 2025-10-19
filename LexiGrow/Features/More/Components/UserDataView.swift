//
//  UserDataView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension MoreScreen {
  struct UserDataView: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        if let user = authManager.currentUser {
          HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
              .font(.system(size: 40))
              .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 6) {
              Text(user.fullName)
                .fontWeight(.semibold)
              Text(user.email)
                .foregroundStyle(.secondary)
            }
            .font(.subheadline)
          }
        } else {
          ProgressView("Retrieving data...")
        }
      }
    }
  }
}

#Preview {
  List {
    MoreScreen.UserDataView()
      .environment(AuthManager.mockObject)
  }
}

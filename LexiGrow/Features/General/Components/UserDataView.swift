//
//  UserDataView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

extension GeneralTabScreen {
  struct UserDataView: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        Text(authManager.currentUser?.username ?? "No username")
          .fontWeight(.semibold)
        Text(authManager.currentUser?.email ?? "No email")
          .foregroundStyle(.secondary)
      }
      .font(.subheadline)
    }
  }
}

#Preview {
  GeneralTabScreen.UserDataView()
    .environment(AuthManager())
}

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
          Text(user.username)
            .fontWeight(.semibold)
          Text(user.email)
            .foregroundStyle(.secondary)
        } else {
          ProgressView()
        }
      }.font(.subheadline)
    }
  }
}

#Preview {
  MoreScreen.UserDataView()
    .environment(AuthManager.mockObject)
}

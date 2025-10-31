//
//  UserDataView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct UserDataView: View {
  let user: AppUser
  
  var body: some View {
    HStack(spacing: 15) {
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 35, height: 35)
      VStack(alignment: .leading, spacing: 6) {
        Text(user.fullName)
          .fontWeight(.semibold)
        Text(user.email)
          .foregroundStyle(.secondary)
      }
      .font(.subheadline)
    }
  }
}

#Preview {
  Form {
    UserDataView(user: .mockUser)
      .environment(AuthManager.mock)
  }
}

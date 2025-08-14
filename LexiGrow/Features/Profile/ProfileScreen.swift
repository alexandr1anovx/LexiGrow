//
//  ProfileScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct ProfileScreen: View {
  @Environment(AuthManager.self) var authManager
  @FocusState private var inputContent: InputFieldContent?
  @State private var username: String = ""
  @State private var email: String = ""
  
  private var formHasChanges: Bool {
    guard let user = authManager.currentUser else { return false }
    let changedUsername = username != user.username
    let changedEmail = email != user.email
    return changedUsername || changedEmail
  }
  
  var body: some View {
    VStack {
      VStack(spacing: 15) {
        Image(systemName: "person.crop.circle.fill")
          .font(.system(size: 80))
          .foregroundStyle(.gray.secondary)
          .padding(.bottom)
        InputField(.standard, "Username", text: $username)
          .focused($inputContent, equals: .username)
          .textInputAutocapitalization(.words)
          .autocorrectionDisabled(true)
        InputField(.standard, "Email", text: $email)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .keyboardType(.emailAddress)
      }
      .padding(.horizontal, 20)
      
      if let error = authManager.updateProfileError {
        Text(error)
          .padding()
          .foregroundStyle(.red)
      }
      
      if authManager.isLoading {
        HStack(spacing: 20) {
          Text("Saving")
          GradientProgressView(tint: .green)
        }
        .padding(20)
      } else {
        Button {
          Task {
            await authManager.updateUser(username: username)
          }
        } label: {
          Text("Save changes")
            .frame(maxWidth: .infinity)
            .padding(11)
        }
        .prominentButtonStyle(tint: .green)
        .disabled(!formHasChanges)
        .padding()
      }
      Spacer()
    }
    .padding(.top)
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Edit") {
          inputContent = .username
        }
      }
    }
    .onAppear {
      retrieveUserData()
    }
  }
  
  private func retrieveUserData() {
    guard let user = authManager.currentUser else {
      username = "No username"
      email = "No email"
      return
    }
    username = user.username
    email = user.email
  }
}

#Preview {
  NavigationView {
    ProfileScreen()
      .environment(AuthManager.mock)
  }
}

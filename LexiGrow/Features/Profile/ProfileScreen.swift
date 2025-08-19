//
//  ProfileScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct ProfileScreen: View {
  @Environment(AuthManager.self) var authManager
  @FocusState private var inputContent: TextFieldContent?
  @State private var username = ""
  @State private var email = ""
  
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
          .foregroundStyle(.secondary)
          .padding(.bottom)
        DefaultTextField(
          title: "Username",
          iconName: "person",
          text: $username
        )
        .focused($inputContent, equals: .username)
        .textInputAutocapitalization(.words)
        .autocorrectionDisabled(true)
        DefaultTextField(
          title: "Email",
          iconName: "at",
          text: $email
        )
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
      }
      .padding(.horizontal, 15)
      
      if let error = authManager.error {
        Text(error.localizedDescription)
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
            .prominentButtonStyle(tint: .green)
        }
        .disabled(!formHasChanges)
        .opacity(!formHasChanges ? 0.5 : 1)
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
      .environment(AuthManager.mockObject)
  }
}

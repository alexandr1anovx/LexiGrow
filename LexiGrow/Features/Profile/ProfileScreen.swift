//
//  ProfileScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct ProfileScreen: View {
  @Environment(AuthManager.self) var authManager
  @FocusState private var fieldContent: TextFieldContent?
  @State private var fullName = ""
  @State private var email = ""
  @State private var isEmailConfirmed: Bool?
  @State private var connectedProviders: [String] = []
  
  private var formHasChanges: Bool {
    guard let user = authManager.currentUser else { return false }
    let changedUsername = fullName != user.fullName
    let changedEmail = email != user.email
    return changedUsername || changedEmail
  }
  
  var body: some View {
    VStack(spacing: 30) {
      Image(systemName: "person.crop.circle.fill")
        .font(.system(size: 80))
      
      VStack(spacing: 10) {
        DefaultTextField(
          title: "Full Name",
          iconName: "person",
          text: $fullName
        )
        .focused($fieldContent, equals: .fullName)
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
      
      if let emailConfirmed = isEmailConfirmed {
        Text(emailConfirmed ? "Email confirmed!" : "Email not confirmed!")
      }
      
      HStack {
        Text("Connected Providers: ")
        ForEach(connectedProviders, id: \.self) {
          Text($0.rawValue)
        }
      }
      
      if formHasChanges {
        PrimaryButton(title: "Save changes", tint: .green) {
          Task {
            await authManager.updateUser(fullName: fullName)
          }
        }
      }
      
      if let error = authManager.error {
        Text(error.localizedDescription)
          .foregroundStyle(.red)
      }
      Spacer()
    }
    .padding(.horizontal, .defaultPadding)
    .onAppear { retrieveUserData() }
    .task {
      self.connectedProviders = await authManager.fetchConnectedProviders()
    }
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.large)
  }
}

#Preview {
  NavigationView {
    ProfileScreen()
      .environment(AuthManager.mockObject)
  }
}

extension ProfileScreen {
  private func retrieveUserData() {
    guard let user = authManager.currentUser else {
      fullName = "Full Name"
      email = "Email address"
      return
    }
    fullName = user.fullName
    email = user.email
  }
}

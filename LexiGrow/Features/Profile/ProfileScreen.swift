//
//  ProfileScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct ProfileScreen: View {
  @State var viewModel: ProfileViewModel
  @FocusState private var inputContent: InputFieldContent?
  
  init(authManager: AuthManager) {
    _viewModel = State(wrappedValue: ProfileViewModel(authManager: authManager))
  }
  
  var body: some View {
    VStack {
      
      // Input Fields
      VStack(spacing: 12) {
        InputField(.standard, "Username", text: $viewModel.username)
          .focused($inputContent, equals: .username)
          .textInputAutocapitalization(.words)
          .autocorrectionDisabled(true)
        InputField(.standard, "Email", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
          .keyboardType(.emailAddress)
      }
      .padding(.horizontal)
      
      // Save Changes button
      Button {
        viewModel.updateUser()
      } label: {
        Text("Save changes")
      }
      .opacity(viewModel.formHasChanges ? 1 : 0.5)
      .padding()
      .frame(maxWidth: .infinity, alignment: .trailing)
      Spacer()
    }
    .padding(.top)
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          inputContent = .username
        } label: {
          Image(systemName: "pencil")
            .foregroundStyle(.blue)
        }
      }
    }
  }
}

#Preview {
  NavigationView {
    ProfileScreen(authManager: AuthManager())
  }
}

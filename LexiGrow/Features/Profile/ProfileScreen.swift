//
//  ProfileScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct ProfileScreen: View {
  @State private var viewModel = ProfileViewModel()
  
  var body: some View {
    NavigationView {
      Form {
        // Section "User Data"
        Section {
          VStack(alignment: .leading, spacing: 8) {
            HStack {
              Text("\(viewModel.name) \(viewModel.surname)")
              Text("•")
              Text(viewModel.username!)
                .font(.callout)
                .fontWeight(.bold)
            }
            Text(viewModel.email)
              .font(.subheadline)
              .foregroundStyle(.secondary)
            Text("Joined: \(viewModel.joinDate)")
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
        } footer: {
          HStack(spacing:5) {
            Text("You can edit your data in")
            NavigationLink {
              EmptyView()
            } label: {
              Text("Settings.")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.primary.opacity(0.9))
                .underline()
            }
          }
        }
        
        // Section "Language"
        Section {
          Button("Language") {
            viewModel.isShownLanguageAlert = true
          }
        }
        // Section (): Account actions
        Section {
          Button("Delete account") {
            viewModel.isShownDeleteAccountSheet = true
          }
          Button("Sign Out") {
            viewModel.isShownSignOutSheet = true
          }
        }.tint(.red)
      }
      .navigationTitle("Profile")
      .navigationBarTitleDisplayMode(.large)
      .sheet(isPresented: $viewModel.isShownSignOutSheet) {
        signOutSheet
      }
      .sheet(isPresented: $viewModel.isShownDeleteAccountSheet) {
        deleteAccountSheet
      }
    }
  }
  
  // MARK: - Subviews
  
  private var signOutSheet: some View {
    VStack(spacing: 10) {
      Text("Sign Out")
        .font(.title3)
        .fontWeight(.semibold)
      Text("Are you sure you want to sign out?")
        .font(.callout)
        .foregroundStyle(.secondary)
      HStack(spacing: 30) {
        Button("Cancel") {
          viewModel.isShownSignOutSheet = false
        }
        .buttonStyle(.bordered)
        Button("Yes, I'm sure") {
          // action
        }
        .fontWeight(.semibold)
        .tint(.red)
      }.padding(.top)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
    .overlay(alignment: .topTrailing) {
      Button {
        viewModel.isShownSignOutSheet = false
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title)
          .symbolRenderingMode(.hierarchical)
      }.padding(20)
    }
  }
  
  private var deleteAccountSheet: some View {
    VStack(spacing: 10) {
      Text("Account Deletion")
        .font(.title3)
        .fontWeight(.semibold)
      Text("Are you sure you want to delete account?")
        .font(.callout)
        .foregroundStyle(.secondary)
      HStack(spacing: 30) {
        Button("Cancel") {
          viewModel.isShownDeleteAccountSheet = false
        }
        .buttonStyle(.bordered)
        Button("Yes, I'm sure") {
          // action
        }
        .fontWeight(.semibold)
        .tint(.red)
      }.padding(.top)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.height(250)])
    .presentationCornerRadius(50)
    .overlay(alignment: .topTrailing) {
      Button {
        viewModel.isShownDeleteAccountSheet = false
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title)
          .symbolRenderingMode(.hierarchical)
      }.padding(20)
    }
  }
}

#Preview {
  ProfileScreen()
}

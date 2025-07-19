//
//  GeneralScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 11.07.2025.
//

import SwiftUI

struct GeneralTabScreen: View {
  private let authManager: AuthManager
  @State private var isShowingSignOutView: Bool = false
  
  init(authManager: AuthManager) {
    self.authManager = authManager
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.mainBackgroundColor.ignoresSafeArea()
        Form {
          userDataSection
          signOutSection
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("General")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isShowingSignOutView) {
          signOutView
        }
      }
    }
  }
  
  // MARK: - Subviews
  
  private var userDataSection: some View {
    Section {
      VStack(alignment: .leading, spacing: 15) {
        Text(authManager.currentUser?.username ?? "No username")
          .fontWeight(.semibold)
        Text(authManager.currentUser?.email ?? "No email")
          .foregroundStyle(.secondary)
      }
      .font(.subheadline)
    } footer: {
      HStack(spacing: 5) {
        Text("Would you like to edit your data?")
        NavigationLink {
          ProfileScreen(authManager: authManager)
        } label: {
          Text("Go to Profile.")
            .font(.footnote)
            .fontWeight(.medium)
            .underline()
        }
      }
    }
  }
  
  private var signOutSection: some View {
    Section {
      Button("Sign Out") { isShowingSignOutView = true }
    }
    .tint(.red)
  }
  
  private var signOutView: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      VStack(spacing: 15) {
        Spacer()
        Text("Sign Out")
          .font(.title2)
          .fontWeight(.bold)
        Text("Are you sure you want to sign out?")
          .font(.callout)
          .foregroundStyle(.secondary)
        
        Button {
          Task { await authManager.signOut() }
        } label: {
          HStack {
            if authManager.isLoading {
              ProgressView().tint(.white)
            }
            Text(authManager.isLoading ? "Signing out..." : "Yes, sign out")
              .fontWeight(.semibold)
              .padding(11)
          }
          .padding(.horizontal,5)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 20))
        .tint(.pink)
        .padding(.top)
      }
      .padding(.bottom)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .presentationDetents([.fraction(0.3)])
      .presentationCornerRadius(50)
      .overlay(alignment: .topTrailing) {
        Button {
          isShowingSignOutView = false
        } label: {
          Image(systemName: "xmark.circle.fill")
            .font(.title)
            .foregroundStyle(.red)
            .symbolRenderingMode(.hierarchical)
        }.padding(20)
      }
    }
  }
}

#Preview {
  GeneralTabScreen(authManager: AuthManager())
}

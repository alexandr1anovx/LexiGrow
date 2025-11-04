//
//  ProfileScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import SwiftUI

struct ProfileScreen: View {
  @Environment(AuthManager.self) var authManager
  
  @State private var fullName = ""
  @State private var email = ""
  @State private var isEmailConfirmed: Bool?
  @State private var connectedProviders: [String] = []
  
  @State private var showSaveButton = false
  @State private var showAccountDeletionAlert = false
  @State private var triggerSuccess = false
  @State private var triggerWarning = false
  
  private var formHasChanges: Bool {
    guard let user = authManager.currentUser else { return false }
    let changedUsername = fullName != user.fullName
    let changedEmail = email != user.email
    return changedUsername || changedEmail
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.mainBackground.ignoresSafeArea()
        Form {
          userInfoSection
          providersSection
          
          Section {
            Button("Видалити обліковий запис") {
              showAccountDeletionAlert.toggle()
              triggerWarning.toggle()
            }
            .tint(.red)
            .sensoryFeedback(.warning, trigger: triggerWarning)
          }
        }
        .scrollContentBackground(.hidden)
      }
      .navigationTitle("Профіль")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          if formHasChanges {
            Button {
              Task {
                await authManager.updateUser(fullName: fullName)
                triggerSuccess.toggle()
              }
            } label: {
              Image(systemName: "checkmark")
            }
            .tint(.green)
            .buttonStyle(.borderedProminent)
            .sensoryFeedback(.success, trigger: triggerSuccess)
          }
        }
      }
      .alert(isPresented: $showAccountDeletionAlert) {
        Alert(
          title: Text("Видалення облікового запису"),
          message: Text("Цю дію неможливо скасувати. Усі ваші досягнення та налаштування буде видалено."),
          primaryButton: .destructive(Text("Видалити")) {
            // perform deletion action
          },
          secondaryButton: .cancel(Text("Скасувати"))
        )
      }
      .onAppear(perform: retrieveUserData)
      .task {
        self.connectedProviders = await authManager.fetchConnectedProviders()
      }
    }
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

// MARK: - Private UI Components
private extension ProfileScreen {
  
  var userInfoSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 50, height: 50)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom)
      
      DefaultTextField(content: .fullName, text: $fullName)
        .textInputAutocapitalization(.words)
      DefaultTextField(content: .email, text: $email)
      
      if let isEmailConfirmed {
        Label {
          Text(isEmailConfirmed ? "Пошту підтверджено" : "Пошту не підтверджено")
        } icon: {
          Image(systemName: isEmailConfirmed ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundStyle(.green)
        }
        .padding(12)
        .opacity(0.5)
      }
    }
  }
  
  var providersSection: some View {
    Section("Провайдери") {
      if connectedProviders.isEmpty {
        Text("Немає підключених провайдерів")
      } else {
        ForEach(connectedProviders, id: \.self) { providerName in
          NavigationLink {
            Text("Провайдер: \(providerName)")
          } label: {
            ProviderRowView(providerName: providerName)
          }
        }
      }
    }
  }
}

struct ProviderRowView: View {
  let providerName: String
  
  private var displayName: String {
    switch providerName {
    case "email": return "Email"
    case "google": return "Google"
    case "apple": return "Apple"
    default: return providerName.capitalized
    }
  }
  
  private var icon: Image {
    switch providerName {
    case "email": return Image(systemName: "envelope.fill")
    case "google": return Image("googleIcon")
    case "apple": return Image(systemName: "apple.logo")
    default: return Image(systemName: "person.badge.key.fill")
    }
  }
  
  var body: some View {
    HStack(spacing: 15) {
      icon
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundStyle(.secondary)
      Text(displayName)
        .fontWeight(.medium)
      Spacer()
    }
    .padding(5)
  }
}

// MARK: - Preview

#Preview {
  NavigationStack {
    ProfileScreen()
      .environment(AuthManager.mock)
  }
}

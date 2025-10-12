//
//  SupabaseAuthService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation
import Supabase

protocol AuthServiceProtocol {
  func signIn(email: String, password: String) async throws -> AppUser
  func signInWithGoogle(bundleId: String) async throws
  
  func signUp(fullName: String, email: String, password: String) async throws -> AppUser
  func signOut() async throws
  func updateUser(fullName: String) async throws -> AppUser
  func getCurrentUser() async throws -> AppUser
  func requestPasswordReset(for email: String) async throws
}

struct AuthService: AuthServiceProtocol {
  
  /// Автентифікує користувача за допомогою електронної пошти та пароля.
  func signIn(email: String, password: String) async throws -> AppUser {
    do {
      let session = try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.invalidCredentials
    }
  }
  
  /// Реєструє нового користувача з іменем, електронною поштою та паролем.
  func signUp(fullName: String, email: String, password: String) async throws -> AppUser {
    do {
      let session = try await SupabaseManager.shared.client.auth.signUp(
        email: email,
        password: password,
        data: ["fullName": .string(fullName)]
      )
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.serverError
    }
  }
  
  /// Виконує вихід поточного користувача із системи.
  func signOut() async throws {
    do {
      try await SupabaseManager.shared.client.auth.signOut()
    } catch {
      throw AuthError.serverError
    }
  }
  
  /// Асинхронно оновлює ім'я поточного автентифікованого користувача.
  func updateUser(fullName: String) async throws -> AppUser {
    let updatedUser = try await SupabaseManager.shared.client.auth.update(
      user: UserAttributes(data: ["fullName": .string(fullName)])
    )
    return try mapSupabaseUserToAppUser(updatedUser)
  }
  
  func getCurrentUser() async throws -> AppUser {
    do {
      let session = try await SupabaseManager.shared.client.auth.session
      return try mapSupabaseUserToAppUser(session.user)
    } catch {
      throw AuthError.unknown(description: error.localizedDescription)
    }
  }
  
  /// Надсилає запит на скидання пароля для вказаної електронної пошти.
  func requestPasswordReset(for email: String) async throws {
    try await SupabaseManager.shared.client.auth.resetPasswordForEmail(email)
  }

  func signInWithGoogle(bundleId: String) async throws {
    try await SupabaseManager.shared.client.auth.signInWithOAuth(
      provider: .google,
      redirectTo: URL(string: "\(bundleId)://"),
      // завжди дозволяє користувачу обрати google-акаунт.
      queryParams: [(name: "prompt", value: "select_account")]
    )
  }
  
  // MARK: - Private methods
  
  /// Перетворює користувача Supabase у внутрішню модель `AppUser`, витягуючи основні дані та метадані користувача.
  private func mapSupabaseUserToAppUser( _ supabaseUser: Supabase.User) throws -> AppUser {
    guard let email = supabaseUser.email else {
      throw AuthError.invalidCredentials
    }
    
    let username: String
    let metadata = supabaseUser.userMetadata
    
    if let nameValue = metadata["full_name"], case .string(let fullName) = nameValue {
      username = fullName
    } else if let nameValue = metadata["username"], case .string(let usrname) = nameValue {
      username = usrname
    } else {
      username = email.components(separatedBy: "@").first ?? "User"
    }
    
    return AppUser(
      id: supabaseUser.id,
      username: username,
      email: email,
      emailConfirmed: supabaseUser.emailConfirmedAt != nil
    )
  }
}

// MARK: - Auth Error

enum AuthError: LocalizedError {
  case invalidCredentials
  case networkError(description: String)
  case serverError
  case emailNotConfirmed
  case unknown(description: String)
  
  var errorDescription: String? {
    switch self {
    case .invalidCredentials:
      return "Неправильна електронна пошта або пароль."
    case .networkError:
      return "Помилка мережі. Будь ласка, перевірте ваше інтернет-з'єднання."
    case .serverError:
      return "Сталася помилка на сервері. Спробуйте пізніше."
    case .emailNotConfirmed:
      return "Будь ласка, підтвердьте вашу електронну пошту."
    case .unknown(let description):
      return "Сталася невідома помилка: \(description)"
    }
  }
}

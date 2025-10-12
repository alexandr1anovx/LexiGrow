//
//  AppSessionManager.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 07.07.2025.
//

import Foundation

enum AuthState {
  case unauthenticated
  case waitingForEmailConfirmation
  case authenticated
}

@Observable
@MainActor
final class AuthManager {
  
  // MARK: - Published Properties
  
  private(set) var currentUser: AppUser?
  private(set) var authState: AuthState = .unauthenticated
  private(set) var error: AuthError?
  private(set) var isLoading = false
  
  private let authService: AuthServiceProtocol
  
  init(authService: AuthServiceProtocol = AuthService()) {
    self.authService = authService
    
    Task { await refreshUser() }
  }
  
  // MARK: - Public API
  
  /// Автентифікує користувача за допомогою електронної пошти та пароля.
  func signIn(email: String, password: String) async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      let user = try await authService.signIn(email: email, password: password)
      updateUserState(with: user)
    } catch {
      handle(error: error)
    }
  }
  
  /// Реєструє нового користувача з іменем, електронною поштою та паролем.
  func signUp(fullName: String, email: String, password: String) async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      let user = try await authService.signUp(fullName: fullName, email: email, password: password)
      if user.emailConfirmed == false {
        self.authState = .waitingForEmailConfirmation
        self.currentUser = user
      } else {
        self.authState = .authenticated
        self.currentUser = user
      }
    } catch {
      handle(error: error)
    }
  }
  
  /// Виконує вихід поточного користувача із системи.
  func signOut() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try await authService.signOut()
      self.currentUser = nil
      self.authState = .unauthenticated
    } catch {
      handle(error: error)
    }
  }
  
  /// Асинхронно оновлює ім'я поточного автентифікованого користувача.
  func updateUser(fullName: String) async {
    guard currentUser != nil else { return }
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      let updatedUser = try await authService.updateUser(fullName: fullName)
      self.currentUser = updatedUser
    } catch {
      handle(error: error)
    }
  }
  
  /// Надсилає запит на скидання пароля для вказаної електронної пошти.
  func requestPasswordReset(for email: String) async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      try await authService.requestPasswordReset(for: email)
    } catch {
      handle(error: error)
    }
  }
  
  /// Оновлює дані поточного користувача з сервера.
  func refreshUser() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let user = try await authService.getCurrentUser()
      updateUserState(with: user)
      self.error = nil
    } catch {
      self.currentUser = nil
      self.authState = .unauthenticated
      handle(error: error)
    }
  }
  
  /// Видаляє акаунт поточного користувача.
  /*
  func deleteUser() async {
    guard currentUser != nil else { return }
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      try await authService.deleteUser()
      self.currentUser = nil
      self.authState = .unauthenticated
    } catch {
      handle(error: error)
    }
  }
  */
  
  // MARK: - 'Sign In With' providers
  
  /// Ініціює процес входу через сервіс Google.
  func signInWithGoogle() async {
    prepareForRequest()
    defer { isLoading = false }
    
    do {
      guard let bundleId = Bundle.main.bundleIdentifier else { return }
      try await authService.signInWithGoogle(bundleId: bundleId)
    } catch {
      handle(error: error)
    }
  }
  
  // MARK: - Private API
  
  /// Готує стан менеджера до нового асинхронного запиту.
  private func prepareForRequest() {
    isLoading = true
    error = nil
  }
  
  /// Оновлює стан користувача та автентифікації на основі отриманого об'єкта AppUser.
  private func updateUserState(with user: AppUser) {
    self.currentUser = user
    self.authState = user.emailConfirmed ? .authenticated : .authenticated
  }
  
  /// Обробляє помилки, оновлюючи стан для відображення в UI.
  private func handle(error: Error) {
    self.error = error as? AuthError ?? .unknown(description: error.localizedDescription)
    self.authState = .unauthenticated
  }
}

// MARK: - Mock Object

extension AuthManager {
  static var mockObject: AuthManager = {
    let manager = AuthManager()
    manager.currentUser = .mockUser
    manager.authState = .authenticated
    manager.error = nil
    manager.isLoading = false
    return manager
  }()
}

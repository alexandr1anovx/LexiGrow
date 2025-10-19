//
//  MockServices.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 21.08.2025.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
  
  func getConnectedProviders() async throws -> [String] {
    []
  }
  
  func signInWithMagicLink(for email: String) async throws {
    //
  }
  func signInWithGoogle(bundleId: String) async throws {
    //
  }
  
  var shouldSucceed = true
  
  var mockUser = AppUser(id: UUID(), fullName: "mockuser", email: "mock@test.com", emailConfirmed: true)
  
  func signIn(email: String, password: String) async throws -> AppUser {
    if shouldSucceed { return mockUser }
    throw AuthError.invalidCredentials
  }
  
  func signUp(fullName: String, email: String, password: String) async throws -> AppUser {
    if shouldSucceed { return mockUser }
    throw AuthError.serverError
  }
  
  func signOut() async throws {
    if !shouldSucceed { throw AuthError.unknown(description: "Unknown error") }
  }
  
  func updateUser(fullName: String) async throws -> AppUser {
    if shouldSucceed {
      mockUser.fullName = fullName
      return mockUser
    }
    throw AuthError.serverError
  }
  
  func getCurrentUser() async throws -> AppUser {
    if shouldSucceed { return mockUser }
    throw AuthError.unknown(description: "User Not Found")
  }
  
  func requestPasswordReset(for email: String) async throws {
    if !shouldSucceed { throw AuthError.unknown(description: "Unknown error") }
  }
}

// MARK: - Mock Supabase Service

class MockSupabaseService: SupabaseServiceProtocol {
  var shouldSucceed = true
  var lessons: [Lesson] = [.mockFlashcards, .mockReading]
  var levels: [Level] = [.mockB1, .mockB2]
  var topics: [Topic] = [.mock1, .mock2, .mock3]
  var topicsProgress: [Topic] = [.mock1, .mock2, .mock3]
  var words: [Word] = [.mock1, .mock2]
  var mockUnlearnedWords: [Word] = [.mock1]
  
  func getLessons() async throws -> [Lesson] {
    if shouldSucceed { return lessons }
    throw AuthError.serverError
  }
  
  func getLevels() async throws -> [Level] {
    if shouldSucceed { return levels }
    throw AuthError.serverError
  }
  
  func getTopics(for levelId: UUID) async throws -> [Topic] {
    if shouldSucceed { return topics }
    throw AuthError.serverError
  }
  
  func getTopics(levelId: UUID, userId: UUID) async throws -> [Topic] {
    if shouldSucceed { return topicsProgress }
    throw AuthError.serverError
  }
  
  func getWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word] {
    if shouldSucceed { return mockUnlearnedWords }
    throw AuthError.serverError
  }
  
  func getWords(levelId: UUID, topicId: UUID) async throws -> [Word] {
    if shouldSucceed { return words }
    throw AuthError.serverError
  }
  
  func markWordAsLearned(wordId: UUID) async throws {
    if !shouldSucceed { throw AuthError.serverError }
  }
  
  func saveLessonProgress(learnedWords: [Word]) async throws {
    if !shouldSucceed { throw AuthError.serverError }
  }
  
  func getSentences(for levelId: UUID) async throws -> [Sentence] {
    if shouldSucceed { return [] }
    throw AuthError.serverError
  }
}

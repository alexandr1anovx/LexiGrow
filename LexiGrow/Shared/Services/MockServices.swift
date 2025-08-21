//
//  MockServices.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 21.08.2025.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
  var shouldSucceed = true
  
  var mockUser = AppUser(id: UUID(), username: "mockuser", email: "mock@test.com", emailConfirmed: true)
  
  func signIn(email: String, password: String) async throws -> AppUser {
    if shouldSucceed { return mockUser }
    throw AuthError.invalidCredentials(description: "Mock error")
  }
  
  func signUp(username: String, email: String, password: String) async throws -> AppUser {
    if shouldSucceed { return mockUser }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func signOut() async throws {
    if !shouldSucceed { throw AuthError.unknown }
  }
  
  func updateUser(username: String) async throws -> AppUser {
    if shouldSucceed {
      mockUser.username = username
      return mockUser
    }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func getCurrentUser() async throws -> AppUser {
    if shouldSucceed { return mockUser }
    throw AuthError.userNotFound
  }
  
  func requestPasswordReset(for email: String) async throws {
    if !shouldSucceed { throw AuthError.unknown }
  }
}

// MARK: - Mock Supabase Service

class MockSupabaseService: SupabaseServiceProtocol {
  var shouldSucceed = true
  var lessons: [Lesson] = [.flashcards, .reading]
  var levels: [Level] = [.mockB1, .mockB2]
  var topics: [Topic] = [.mockAppearance]
  var topicsProgress: [TopicProgress] = [.mock1, .mock2, .mock3]
  var words: [Word] = [.mock1, .mock2]
  var mockUnlearnedWords: [Word] = [.mock3]
  
  func getLessons() async throws -> [Lesson] {
    if shouldSucceed { return lessons }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func getLevels() async throws -> [Level] {
    if shouldSucceed { return levels }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func getTopics(for levelId: UUID) async throws -> [Topic] {
    if shouldSucceed { return topics }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func getTopicProgress(levelId: UUID, userId: UUID) async throws -> [TopicProgress] {
    if shouldSucceed { return topicsProgress }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func getUnlearnedWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word] {
    if shouldSucceed { return mockUnlearnedWords }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func getWords(levelId: UUID, topicId: UUID) async throws -> [Word] {
    if shouldSucceed { return words }
    throw AuthError.serverError(description: "Mock error")
  }
  
  func markWordAsLearned(wordId: UUID) async throws {
    if !shouldSucceed { throw AuthError.serverError(description: "Mock error") }
  }
  
  func saveLessonProgress(learnedWords: [Word]) async throws {
    if !shouldSucceed { throw AuthError.serverError(description: "Mock error") }
  }
  
  func getSentences(for levelId: UUID) async throws -> [Sentence] {
    if shouldSucceed { return [] }
    throw AuthError.serverError(description: "Mock error")
  }
}

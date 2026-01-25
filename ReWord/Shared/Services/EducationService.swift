//
//  SupabaseService.swift
//  ReWord
//
//  Created by Alexander Andrianov on 04.08.2025.
//

import Foundation

protocol EducationServiceProtocol {
  func getLessons() async throws -> [LessonDTO]
  func getLevels() async throws -> [Level]
  func getTopics(levelId: UUID, userId: UUID) async throws -> [Topic]
  func getWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word]
  func markWordAsLearned(wordId: UUID) async throws
  func saveLessonProgress(learnedWords: [Word]) async throws
}

@Observable
final class EducationService: EducationServiceProtocol {
  
  /// Loads the list of all lessons from the database, sorted by lock status.
  func getLessons() async throws -> [LessonDTO] {
    let lessons: [LessonDTO] = try await SupabaseService.shared.client
      .from("lessons")
      .select()
      .order("is_locked")
      .execute()
      .value
    return lessons
  }
  
  /// Loads the list of all levels, sorted by their order index.
  func getLevels() async throws -> [Level] {
    let levels: [Level] = try await SupabaseService.shared.client
      .from("levels")
      .select()
      .order("order_index")
      .execute()
      .value
    return levels
  }
  
  /// Loads words for a specific lesson and user, excluding words already learned.
  /// - Parameters:
  ///   - levelId: The level identifier.
  ///   - topicId: The topic (lesson) identifier.
  ///   - userId: The current user's identifier.
  /// - Returns: An array of unlearned words `[Word]`.
  func getWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word] {
    let params: [String: UUID] = [
      "p_user_id": userId,
      "p_level_id": levelId,
      "p_topic_id": topicId
    ]
    let words: [Word] = try await SupabaseService.shared.client
      .rpc("get_unlearned_words_for_lesson", params: params)
      .execute()
      .value
    return words
  }
  
  /// Loads topics and their learning progress for a specific level and user.
  /// - Parameters:
  ///   - levelId: The level identifier for which topics are loaded.
  ///   - userId: The current user's identifier used to compute progress.
  /// - Returns: An array of topics `[Topic]` with progress information.
  func getTopics(levelId: UUID, userId: UUID) async throws -> [Topic] {
    let params: [String: UUID] = [
      "p_level_id": levelId,
      "p_user_id": userId
    ]
    let progressList: [Topic] = try await SupabaseService.shared.client
      .rpc("get_topic_progress", params: params)
      .execute()
      .value
    return progressList
  }
  
  /// Marks a single word as learned for the current user.
  /// - Parameter wordId: The identifier of the word to mark as learned.
  func markWordAsLearned(wordId: UUID) async throws {
    let user = try await SupabaseService.shared.client.auth.user()
    let progress = UserProgress(
      userId: user.id,
      wordId: wordId,
      learnedAt: Date.now
    )
    try await SupabaseService.shared.client
      .from("user_progress")
      .upsert(progress) // .upsert() prevents an error if the user learns the same word twice.
      .execute()
  }
  
  /// Saves progress for an array of words learned during a lesson.
  /// - Parameter learnedWords: An array of words `[Word]` that were learned.
  func saveLessonProgress(learnedWords: [Word]) async throws {
    guard !learnedWords.isEmpty else { return }
    let user = try await SupabaseService.shared.client.auth.user()
    let progressArray = learnedWords.map { word in
      UserProgress(userId: user.id, wordId: word.id, learnedAt: Date())
    }
    try await SupabaseService.shared.client
      .from("user_progress")
      .upsert(progressArray)
      .execute()
  }
}

extension EducationService {
  static let mock = EducationService()
}

//
//  SupabaseService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 04.08.2025.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: Constants.supabaseURL)!,
  supabaseKey: Constants.supabaseAPIKey
)

protocol SupabaseServiceProtocol {
  func getLessons() async throws -> [Lesson]
  func getLevels() async throws -> [Level]
  func getTopics(for levelId: UUID) async throws -> [Topic]
  func getTopicProgress(levelId: UUID, userId: UUID) async throws -> [TopicProgress]
  func getUnlearnedWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word]
  func getSentences(for levelId: UUID) async throws -> [Sentence]
  // func getWords(levelId: UUID, topicId: UUID) async throws -> [Word]
  func markWordAsLearned(wordId: UUID) async throws
  func saveLessonProgress(learnedWords: [Word]) async throws
  
}

@Observable final class SupabaseService: SupabaseServiceProtocol {
  
  func getLessons() async throws -> [Lesson] {
    let lessons: [Lesson] = try await supabase
      .from("lessons")
      .select()
      .order("is_locked")
      .execute()
      .value
    return lessons
  }
  
  func getLevels() async throws -> [Level] {
    let levels: [Level] = try await supabase
      .from("levels")
      .select()
      .order("order_index")
      .execute()
      .value
    return levels
  }
  
  /// Loads all topics for a selected level.
  func getTopics(for levelId: UUID) async throws -> [Topic] {
    let response: [Topic] = try await supabase
      .from("level_topics")
      .select("topics(*)")
      .eq("level_id", value: levelId)
      .execute()
      .value
    let topics = response
    return topics
  }
  
  /// Loads only unlearned words for specific lesson and user.
  func getUnlearnedWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word] {
    let params: [String: UUID] = [
      "p_user_id": userId,
      "p_level_id": levelId,
      "p_topic_id": topicId
    ]
    let words: [Word] = try await supabase
      .rpc("get_unlearned_words_for_lesson", params: params)
      .execute()
      .value
    return words
  }
  
  /*
  /// Loads all words for a selected level and topic.
  func getWords(
    levelId: UUID,
    topicId: UUID
  ) async throws -> [Word] {
    let params = [
      "p_level_id": levelId,
      "p_topic_id": topicId
    ]
    let words: [Word] = try await supabase
      .rpc("get_words_for_lesson", params: params)
      .execute()
      .value
    return words
  }
  */
  
  /// Loads progress for all topics for a specific level and user.
  /// Calls the RPC-function 'get_level_progress' on the server.
  func getTopicProgress(levelId: UUID, userId: UUID) async throws -> [TopicProgress] {
    let params: [String: UUID] = [
      "p_level_id": levelId,
      "p_user_id": userId
    ]
    let progressList: [TopicProgress] = try await supabase
      .rpc("get_level_progress", params: params)
      .execute()
      .value
    return progressList
  }
  
  func markWordAsLearned(wordId: UUID) async throws {
    let user = try await supabase.auth.user()
    let progress = UserProgress(
      userId: user.id,
      wordId: wordId,
      learnedAt: Date.now
    )
    try await supabase
      .from("user_progress")
    // Using .upsert() for insertion prevents an error, if the user learns the same word twice. If the record already exist, nothing will happen.
      .upsert(progress)
      .execute()
  }
  
  func saveLessonProgress(learnedWords: [Word]) async throws {
    guard !learnedWords.isEmpty else { return }
    let user = try await supabase.auth.user()
    let progressArray = learnedWords.map { word in
      UserProgress(userId: user.id, wordId: word.id, learnedAt: Date())
    }
    try await supabase
      .from("user_progress")
      .upsert(progressArray)
      .execute()
  }
  
  func getSentences(for levelId: UUID) async throws -> [Sentence] {
    let params = ["p_level_id": levelId]
    let sentences: [Sentence] = try await supabase
      .rpc("get_sentences_for_level", params: params)
      .execute()
      .value
    return sentences
  }
}

extension SupabaseService {
  static let mockObject = SupabaseService()
}

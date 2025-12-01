//
//  SpySupabaseService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.09.2025.
//

import XCTest
@testable import LexiGrow

final class SpyEducationService: EducationServiceProtocol {
  var getLessonsCalled = false
  var getLevelsCalled = false
  var getTopicsCalled = false
  var getWordsCalled = false
  var saveLessonProgressCalled = false

  var lessonsToReturn: [LessonDTO] = [.mockCards, .mockReading]
  var levelsToReturn: [Level] = [.mockB1, .mockB2]
  var topicsToReturn: [Topic] = [.mock1, .mock2, .mock3]
  var wordsToReturn: [Word] = [.mock1, .mock2]

  var getLessonsError: Error?
  var getLevelsError: Error?
  var getTopicsError: Error?
  var getWordsError: Error?
  var saveProgressError: Error?

  func getLessons() async throws -> [LessonDTO] {
    getLessonsCalled = true
    if let e = getLessonsError { throw e }
    return lessonsToReturn
  }

  func getLevels() async throws -> [Level] {
    getLevelsCalled = true
    if let e = getLevelsError { throw e }
    return levelsToReturn
  }

  func getTopics(levelId: UUID, userId: UUID) async throws -> [Topic] {
    getTopicsCalled = true
    if let e = getTopicsError { throw e }
    return topicsToReturn
  }

  func getWords(levelId: UUID, topicId: UUID, userId: UUID) async throws -> [Word] {
    getWordsCalled = true
    if let e = getWordsError { throw e }
    return wordsToReturn
  }

  func getSentences(for levelId: UUID) async throws -> [Sentence] {
    // Not used in these tests.
    return []
  }

  func markWordAsLearned(wordId: UUID) async throws {
    // Not used in these tests.
  }

  func saveLessonProgress(learnedWords: [Word]) async throws {
    saveLessonProgressCalled = true
    if let e = saveProgressError { throw e }
  }
}

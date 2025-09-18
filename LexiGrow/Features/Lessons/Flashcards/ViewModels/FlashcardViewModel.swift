//
//  FlashcardsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

@Observable
@MainActor
final class FlashcardViewModel {
  
  // MARK: - Public properties
  
  var lessonState: LessonState = .inProgress
  var sortOption: TopicSortOption = .defaultOrder
  var selectedLevel: Level?
  var selectedTopic: Topic?
  
  // MARK: - Private(set) properties
  
  var words: [Word] = []
  var currentWordIndex: Int = 0
  var knownWords: [Word] = []
  var unknownWords: [Word] = []
  var levels: [Level] = []
  var topics: [Topic] = []
  var errorMessage: String?
  
  // MARK: - Private properties
  
  private let supabaseService: SupabaseServiceProtocol
  
  // MARK: - Computed Properties
  
  /// Computed property that returns sorted list of topics.
  var sortedTopics: [Topic] {
    switch sortOption {
    case .defaultOrder:
      return topics
    case .uncompletedFirst:
      return topics.sorted { $0.progress < $1.progress }
    case .completedFirst:
      return topics.sorted { $0.progress > $1.progress }
    case .alphabeticalAZ:
      return topics.sorted { $0.name < $1.name }
    }
  }
  
  /// The current word displayed on the card. Returns `nil` if the lesson has not started or there are no more words.
  var currentWord: Word? {
    guard words.indices.contains(currentWordIndex) else {
      return nil
    }
    return words[currentWordIndex]
  }
  
  /// The progress of the current lesson as a value from 0.0 to 1.0.
  var lessonProgress: Double {
    guard !words.isEmpty else { return 0.0 }
    let raw = Double(currentWordIndex + 1) / Double(words.count)
    return min(raw, 1.0)
  }
  
  var lessonAccuracy: Double {
    guard !words.isEmpty else { return 0.0 }
    let correctAnswers = Double(knownWords.count)
    return correctAnswers / Double(words.count)
  }
  
  var lessonFeedbackTitle: String {
    switch lessonProgress {
    case 0.8...: return "Excellent Work!"
    case 0.5..<0.8: return "Good Job!"
    default: return "Keep Practicing!"
    }
  }
  
  var lessonFeedbackIconName: String {
    switch lessonProgress {
    case 0.8...: return "hands.clap.fill"
    case 0.5..<0.8: return "face.smiling"
    default: return "figure.play.circle.fill"
    }
  }
  
  var canStartLesson: Bool {
    selectedLevel != nil && selectedTopic != nil
  }
  
  // MARK: - Init
  
  init(supabaseService: SupabaseServiceProtocol) {
    self.supabaseService = supabaseService
  }
  
  // MARK: - Public methods
  
  /// Starts a new lesson with flashcards.
  ///
  /// Resets the lesson data and starts loading words for the level and topic selected by the user.
  func startLesson() {
    currentWordIndex = 0
    knownWords = []
    unknownWords = []
    lessonState = .inProgress
    getWords()
  }
  
  /// Handles the user's action when they mark a word as "known".
  ///
  /// Immediately moves to the next card, adds the word to the local `knownWords` set,
  /// and starts a background task to save the progress on the server.
  func handleKnownWord() {
    guard let word = currentWord else { return }
    knownWords.append(word)
    selectNextWord()
  }
  
  /// Handles the user's action when they mark a word as "unknown".
  ///
  /// Adds the word to the local `unknownWords` set for statistics within the current session and moves on to the next card.
  func handleUnknownWord() {
    guard let word = currentWord else { return }
    unknownWords.append(word)
    selectNextWord()
  }
  
  func resetSetupData() {
    selectedLevel = nil
    selectedTopic = nil
  }
  
  /// Loads a list of all available levels from the backend.
  ///
  /// If successful, fills in the `levels` property. If an error occurs, updates `errorMessage`.
  func getLevels() {
    guard levels.isEmpty else { return }
    Task {
      do {
        self.levels = try await supabaseService.getLevels()
      } catch {
        errorMessage = "Failed to get levels: \(error)"
      }
    }
  }
  
  /// Loads topics and user progress for the selected level.
  ///
  /// Requires that the `selectedLevel` property be set. If successful, fills the `topicsProgress` array.
  /// If an error occurs or the user is not authenticated, updates `errorMessage`.
  func getTopics() {
    guard let level = selectedLevel else { return }
    Task {
      do {
        let user = try await supabase.auth.user()
        let progress = try await supabaseService.getTopics(
          levelId: level.id,
          userId: user.id
        )
        topics = progress
      } catch {
        errorMessage = "Failed to get topics progress: \(error)"
      }
    }
  }

  /// Loads unlearned words for the selected level and topic, shuffling the result.
  ///
  /// Requires `selectedLevel` and `selectedTopic`. On success assigns to `words`;
  /// on failure sets `errorMessage`. Runs asynchronously on the main actor.
  func getWords() {
    guard let level = selectedLevel, let topic = selectedTopic else { return }
    Task {
      do {
        let user = try await supabase.auth.user()
        let fetchedWords = try await supabaseService.getWords(
          levelId: level.id,
          topicId: topic.id,
          userId: user.id
        )
        self.words = fetchedWords.shuffled()
      } catch {
        errorMessage = "Failed to load words: \(error)"
      }
    }
  }
  
  func saveLessonProgress() {
    Task {
      do {
        try await supabaseService.saveLessonProgress(learnedWords: knownWords)
      } catch {
        errorMessage = "Failed to save lesson progress: \(error)"
        print("Failed to save lesson progress: \(error)")
      }
    }
  }
  
  // MARK: - Private methods
  
  /// Advances to the next word in the list by incrementing the current index.
  /// If the end of the list is reached, transitions to the summary screen.
  private func selectNextWord() {
    if currentWordIndex < words.count - 1 {
      currentWordIndex += 1
    } else {
      lessonState = .summary
      currentWordIndex = words.count
    }
  }
}

// MARK: - Lesson State

extension FlashcardViewModel {
  enum LessonState {
    case inProgress, summary
  }
}

// MARK: - Preview Mode

extension FlashcardViewModel {
  static var mockObject: FlashcardViewModel = {
    let viewModel = FlashcardViewModel(supabaseService: MockSupabaseService())
    viewModel.selectedLevel = Level.mockB1
    viewModel.selectedTopic = Topic.mock1
    viewModel.words = [Word.mock1]
    return viewModel
  }()
}

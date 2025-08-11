//
//  FlashcardsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation

@Observable
@MainActor
final class FlashcardViewModel {
  
  // MARK: - Public properties
  
  var errorMessage: String?
  var lessonState: LessonState = .inProgress
  var selectedLevel: Level?
  var selectedTopic: Topic?
  
  // MARK: - Private properties
  
  private(set) var words: [Word] = []
  private(set) var currentIndex: Int = 0
  private(set) var knownWords: [Word] = []
  private(set) var unknownWords: [Word] = [Word.mock]
  private(set) var levels: [Level] = []
  private(set) var topicsProgress: [TopicProgress] = []
  
  private let supabaseService: SupabaseService
  
  // MARK: - Computed Properties
  
  /// The current word displayed on the card. Returns `nil` if the lesson has not started or there are no more words.
  var currentWord: Word? {
    guard words.indices.contains(currentIndex) else {
      return nil
    }
    return words[currentIndex]
  }
  
  /// The progress of the current lesson as a value from 0.0 to 1.0.
  var progress: Double {
    guard !words.isEmpty else { return 0.0 }
    let raw = Double(currentIndex + 1) / Double(words.count)
    return min(raw, 1.0)
  }
  
  var resultProgress: Double {
    guard !words.isEmpty else { return 0.0 }
    let correctAnswers = Double(knownWords.count)
    return correctAnswers / Double(words.count)
  }
  
  var summaryTitle: String {
    switch progress {
    case 0.8...: return "Excellent Work! 🏆"
    case 0.5..<0.8: return "Good Job! 👍"
    default: return "Keep Practicing! 💪"
    }
  }
  
  var isStartDisabled: Bool {
    selectedLevel == nil || selectedTopic == nil
  }
  
  // MARK: - Init
  
  init(supabaseService: SupabaseService) {
    self.supabaseService = supabaseService
    getLevels()
  }
  
  // MARK: - Public methods
  
  /// Starts a new lesson with flashcards.
  ///
  /// Resets the lesson data and starts loading words for the level and topic selected by the user.
  func startLesson() {
    currentIndex = 0
    knownWords = []
    unknownWords = []
    lessonState = .inProgress
    getWords()
  }
  
  /// Handles the user's action when they mark a word as "known".
  ///
  /// Immediately moves to the next card, adds the word to the local `knownWords` set,
  /// and starts a background task to save the progress on the server.
  func handleKnown() {
    guard let word = currentWord else { return }
    knownWords.append(word)
    selectNextCard()
  }
  
  /// Handles the user's action when they mark a word as "unknown".
  ///
  /// Adds the word to the local `unknownWords` set for statistics within the current session
  /// and moves on to the next card.
  func handleUnknown() {
    guard let word = currentWord else { return }
    unknownWords.append(word)
    selectNextCard()
  }
  
  func resetLevelAndTopic() {
    selectedLevel = nil
    selectedTopic = nil
  }
  
  /// Loads a list of all available levels from the backend.
  ///
  /// If successful, fills in the `levels` property. If an error occurs, updates `errorMessage`.
  func getLevels() {
    Task {
      do {
        self.levels = try await supabaseService.getLevels()
      } catch {
        errorMessage = "Failed to get levels: \(error.localizedDescription)"
      }
    }
  }
  
  /// Loads topics and user progress for the selected level.
  ///
  /// Requires that the `selectedLevel` property be set. If successful, fills the `topicsProgress` array.
  /// If an error occurs or the user is not authenticated, updates `errorMessage`.
  func getTopics() {
    topicsProgress = []
    guard let level = selectedLevel else { return }
    Task {
      do {
        let user = try await supabase.auth.user()
        let progress = try await supabaseService.getTopicProgress(
          levelId: level.id,
          userId: user.id
        )
        topicsProgress = progress
      } catch {
        errorMessage = "Failed to get topics progress: \(error.localizedDescription)"
      }
    }
  }
  
  /// Loads the list of words for the selected level and topic.
  ///
  /// Requires that the `selectedLevel` and `selectedTopic` properties be set. If successful, fills the `words` array, preparing to start the lesson. If an error occurs, updates `errorMessage`.
  func getWords() {
    guard let level = selectedLevel, let topic = selectedTopic else {
      return
    }
    Task {
      do {
        let fetchedWords = try await supabaseService.getWords(
          levelId: level.id,
          topicId: topic.id
        )
        self.words = fetchedWords
      } catch {
        errorMessage = "Failed to load words: \(error.localizedDescription)"
      }
    }
  }
  
  func saveLessonProgress() async {
    do {
      try await supabaseService.saveLessonProgress(learnedWords: knownWords)
    } catch {
      errorMessage = "Failed to save words: \(error)"
    }
  }
  
  // MARK: - Private methods
  
  /// Advances to the next word in the list by incrementing the current index.
  /// If the end of the list is reached, transitions to the summary screen with animation.
  private func selectNextCard() {
    if currentIndex < words.count - 1 {
      currentIndex += 1
    } else {
      lessonState = .summary
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
  static var previewMode: FlashcardViewModel {
    let viewModel = FlashcardViewModel(supabaseService: SupabaseService.mock)
    viewModel.selectedLevel = Level.mock
    viewModel.selectedTopic = Topic.mock
    viewModel.words = [Word.mock]
    return viewModel
  }
}

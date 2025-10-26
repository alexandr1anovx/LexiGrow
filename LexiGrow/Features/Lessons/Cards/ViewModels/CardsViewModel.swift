//
//  CardsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

@Observable
@MainActor
final class CardsViewModel {
  
  // MARK: - Public properties
  
  var lessonState: LessonState = .inProgress
  var topicSortOption: TopicSortOption = .defaultOrder
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
  
  private let educationService: EducationServiceProtocol
  private let speechService: SpeechServiceProtocol
  
  // MARK: - Computed Properties
  
  /// Computed property that returns sorted list of topics.
  var sortedTopics: [Topic] {
    switch topicSortOption {
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
  
  init(
    educationService: EducationServiceProtocol,
    speechService: SpeechServiceProtocol = SpeechService.shared
  ) {
    self.educationService = educationService
    self.speechService = speechService
  }
  
  // MARK: - Public methods
  
  /// Starts a new lesson with cards.
  ///
  /// Resets the lesson data and starts loading words for the level and topic selected by the user.
  func startLesson() async {
    currentWordIndex = 0
    knownWords = []
    unknownWords = []
    lessonState = .inProgress
    await getWords()
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
  func getLevels() async {
    guard levels.isEmpty else { return }
    do {
      self.levels = try await educationService.getLevels()
    } catch {
      errorMessage = "Failed to get levels: \(error)"
    }
  }
  
  /// Loads topics and user progress for the selected level.
  ///
  /// Requires that the `selectedLevel` property be set. If successful, fills the `topicsProgress` array.
  /// If an error occurs or the user is not authenticated, updates `errorMessage`.
  func getTopics() async {
    guard let level = selectedLevel else { return }
    do {
      let user = try await SupabaseService.shared.client.auth.user()
      let progress = try await educationService.getTopics(
        levelId: level.id,
        userId: user.id
      )
      topics = progress
    } catch {
      errorMessage = "Failed to get topics progress: \(error)"
    }
  }

  /// Loads unlearned words for the selected level and topic, shuffling the result.
  ///
  /// Requires `selectedLevel` and `selectedTopic`. On success assigns to `words`;
  /// on failure sets `errorMessage`. Runs asynchronously on the main actor.
  func getWords() async {
    guard let level = selectedLevel, let topic = selectedTopic else { return }
    do {
      let user = try await SupabaseService.shared.client.auth.user()
      let fetchedWords = try await educationService.getWords(
        levelId: level.id,
        topicId: topic.id,
        userId: user.id
      )
      self.words = fetchedWords.shuffled()
    } catch {
      errorMessage = "Failed to load words: \(error)"
    }
  }
  
  func saveLessonProgress() async {
    do {
      try await educationService.saveLessonProgress(learnedWords: knownWords)
    } catch {
      errorMessage = "Failed to save lesson progress: \(error)"
      print("Failed to save lesson progress: \(error)")
    }
  }
  
  // MARK: - Speech
  
  func speakOriginal() {
    guard let word = currentWord else { return }
    speechService.languageCode = "en-US"
    speechService.speak(text: word.original)
  }
  
  func speakCurrentWord(auto: Bool) {
    guard auto else { return }
    speakOriginal()
  }
  
  func stopSpeech(immediately: Bool = false) {
    speechService.stop(immediately: immediately)
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

extension CardsViewModel {
  enum LessonState {
    case inProgress, summary
  }
}

// MARK: - Preview Mode

extension CardsViewModel {
  static var mock: CardsViewModel = {
    let viewModel = CardsViewModel(educationService: MockEducationService())
    viewModel.selectedLevel = .mockB1
    viewModel.topics = [.mock1, .mock2]
    viewModel.words = [.mock1, .mock2, .mock1]
    viewModel.knownWords = [.mock1]
    viewModel.unknownWords = [.mock1]
    return viewModel
  }()
}

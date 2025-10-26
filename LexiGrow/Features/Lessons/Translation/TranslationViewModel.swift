//
//  TranslationViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.08.2025.
//

import Foundation

@Observable
@MainActor
final class TranslationViewModel {
  
  /// The translation direction for the current sentence.
  enum TranslationDirection {
    case toUkrainian, toEnglish
  }
  /// The evaluation state of the user's answer.
  enum AnswerState {
    case idle, correct, incorrect
  }
  
  private(set) var sentences: [Sentence] = []
  private(set) var currentIndex = 0
  private(set) var direction: TranslationDirection = .toUkrainian
  private(set) var levels: [Level] = []
  
  var userInput = ""
  var answerState: AnswerState = .idle
  var selectedLevel: Level?
  
  private let educationService: EducationServiceProtocol
  
  init(educationService: EducationServiceProtocol) {
    self.educationService = educationService
  }
  
  // MARK: - Computed Properties
  
  /// The currently active sentence, or `nil` if the index is out of bounds or the list is empty.
  var currentSentence: Sentence? {
    guard sentences.indices.contains(currentIndex) else { return nil }
    return sentences[currentIndex]
  }
  
  /// The source text that the user needs to translate based on the current direction.
  var sourceText: String {
    guard let currentSentence else { return "Loading..." }
    return direction == .toUkrainian ? currentSentence.englishSentence : currentSentence.ukrainianSentence
  }
  
  /// The correct answer for the current sentence based on the current direction.
  private var correctAnswer: String {
    guard let currentSentence else { return "" }
    return direction == .toUkrainian ? currentSentence.ukrainianSentence : currentSentence.englishSentence
  }
  
  // MARK: - Public Methods
  
  /// Starts a new lesson for the selected level:
  /// - Loads sentences for the selected level from the backend.
  /// - Shuffles the sentences to add variability.
  /// - Resets the current index and sets the initial direction to `.toUkrainian`.
  ///
  /// If `selectedLevel` is not set, this method does nothing.
  func startLesson() async {
    guard let level = selectedLevel else { return }
    do {
      sentences = try await educationService.getSentences(for: level.id).shuffled()
      currentIndex = 0
      direction = .toUkrainian
    } catch {
      print("Failed to load sentences: \(error)")
    }
  }
  
  /// Checks the user's input against the correct answer:
  /// - Trims whitespaces/newlines and lowercases both strings for a lenient comparison.
  /// - Updates `answerState` to `.correct` or `.incorrect`.
  /// - Automatically advances to the next sentence after a 1.5 second delay.
  func checkAnswer() {
    let formattedUserInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    let formattedCorrectAnswer = correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    
    if formattedUserInput == formattedCorrectAnswer {
      answerState = .correct
    } else {
      answerState = .incorrect
    }
    
    // Move to the next sentence after 1.5 seconds.
    Task {
      try? await Task.sleep(for: .seconds(1.5))
      await MainActor.run {
        self.nextSentence()
      }
    }
  }
  
  /// Fetches the list of available levels from the backend if not already loaded.
  /// Subsequent calls are ignored if `levels` is non-empty.
  func getLevels() async {
    guard levels.isEmpty else { return }
    do {
      self.levels = try await educationService.getLevels()
    } catch {
      print("⚠️ Failed to get levels: \(error)")
    }
  }
  
  // MARK: - Private Methods
  
  /// Advances to the next sentence in the lesson:
  /// - Increments `currentIndex` if possible.
  /// - Clears `userInput` and resets `answerState` to `.idle`.
  /// - Randomizes the next translation direction.
  ///
  /// If there are no more sentences, logs that the lesson is finished.
  private func nextSentence() {
    if currentIndex < sentences.count - 1 {
      currentIndex += 1
      userInput = ""
      answerState = .idle
      direction = Bool.random() ? .toUkrainian : .toEnglish
    } else {
      print("🎉 The lesson is finished!")
    }
  }
}

extension TranslationViewModel {
  /// A mock object for previews and testing.
  static var mock: TranslationViewModel = {
    let vm = TranslationViewModel(educationService: EducationService.mock)
    vm.sentences = [
      Sentence(
        id: UUID(),
        englishSentence: "Hello, Swift",
        ukrainianSentence: "Привіт, Свіфт!"
      )
    ]
    return vm
  }()
}

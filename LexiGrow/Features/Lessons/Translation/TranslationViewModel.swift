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
  
  enum TranslationDirection {
    case toUkrainian, toEnglish
  }
  
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
  
  private let service: SupabaseService
  
  init(supabaseService: SupabaseService) {
    self.service = supabaseService
  }
  
  // MARK: - Computed Properties
  
  var currentSentence: Sentence? {
    guard sentences.indices.contains(currentIndex) else { return nil }
    return sentences[currentIndex]
  }
  
  var sourceText: String {
    guard let currentSentence else { return "Loading..." }
    return direction == .toUkrainian ? currentSentence.englishSentence : currentSentence.ukrainianSentence
  }
  
  private var correctAnswer: String {
    guard let currentSentence else { return "" }
    return direction == .toUkrainian ? currentSentence.ukrainianSentence : currentSentence.englishSentence
  }
  
  // MARK: - Public Methods
  
  func startLesson() async {
    guard let level = selectedLevel else { return }
    do {
      sentences = try await service.getSentences(for: level.id).shuffled()
      currentIndex = 0
      direction = .toUkrainian
    } catch {
      print("⚠️ Failed to load sentences: \(error)")
    }
  }
  
  func checkAnswer() {
    let formattedUserInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    let formattedCorrectAnswer = correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    
    if formattedUserInput == formattedCorrectAnswer {
      answerState = .correct
    } else {
      answerState = .incorrect
    }
    
    // Через 1.5 секунди переходимо до наступного речення
    Task {
      try? await Task.sleep(for: .seconds(1.5))
      await MainActor.run {
        self.nextSentence()
      }
    }
  }
  
  func getLevels() {
    guard levels.isEmpty else { return }
    Task {
      do {
        self.levels = try await service.getLevels()
        print("✅ GET LEVELS method executed!")
      } catch {
        print("⚠️ Failed to get levels: \(error)")
        //errorMessage = "Failed to get levels: \(error)"
      }
    }
  }
  
  // MARK: - Private Methods
  
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
  static var mockObject: TranslationViewModel {
    let vm = TranslationViewModel(supabaseService: SupabaseService.mockObject)
    vm.sentences = [
      Sentence(
      id: UUID(),
      englishSentence: "Hello, Swift",
      ukrainianSentence: "Привіт, Сфіфт!"
    )]
    return vm
  }
}

//
//  FlashcardsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation
import SwiftUICore

@MainActor
@Observable
final class FlashcardsViewModel {
  
  // MARK: - Properties
  
  var lessonState: LessonState = .inProgress
  private(set) var cards: [Flashcard] = []
  private(set) var currentIndex: Int = 0
  
  private(set) var knownWordsCount: Int = 0
  
  private(set) var knownWords: Set<Word> = []
  private(set) var unknownWords: Set<Word> = []
  
  var selectedLevel: String?
  var selectedTopic: String?
  
  var levels: [String] = []
  var topics: [String] = []
  
  // MARK: - Computed Properties
  
  var currentCard: Flashcard? {
    guard cards.indices.contains(currentIndex) else {
      return nil
    }
    return cards[currentIndex]
  }
  
  var progress: Double {
    guard !cards.isEmpty else { return 0.0 }
    let raw = Double(currentIndex + 1) / Double(cards.count)
    return min(raw, 1.0)
  }
  
  /*
  var knownWordsProgress: Double {
    guard !knownWords.isEmpty else { return 0.0 }
    let raw = Double(currentIndex + 1) / Double(knownWords.count)
    return min(raw, 1.0)
  }
  
  var unknownWordsProgress: Double {
    guard !unknownWords.isEmpty else { return 0.0 }
    let raw = Double(currentIndex + 1) / Double(unknownWords.count)
    return min(raw, 1.0)
  }
  */
  
  var isStartDisabled: Bool {
    selectedLevel == nil || selectedTopic == nil
  }
  
  // MARK: - Init / Deinit
  
  init() { print("Flashcard view model initialized") }
  deinit { print("Flashcard view model deinitialized") }
  
  // MARK: - Public Methods
  
  func startLesson() {
    if let level = selectedLevel, let topic = selectedTopic {
      let words = WordService.getWords(for: level, topic: topic)
      self.cards = words.map {
        Flashcard(id: $0.id, word: $0)
      }
      self.currentIndex = 0
      self.knownWordsCount = 0
      self.knownWords = []
      self.unknownWords = []
      self.unknownWords.removeAll()
      self.lessonState = .inProgress
    }
  }
  
  func handleKnown() {
    guard let card = currentCard else { return }
    
    if unknownWords.contains(card.word) {
      unknownWords.remove(card.word)
    } else {
      knownWords.insert(card.word)
      knownWordsCount += 1
    }
    selectNextCard()
  }
  
  func handleUnknown() {
    guard let card = currentCard else { return }
    unknownWords.insert(card.word)
    selectNextCard()
  }
  
  func resetSetupSettings() {
    selectedLevel = nil
    selectedTopic = nil
  }
  
  func getLevels() {
    levels = WordService.getLevels()
  }
  
  func resetTopics() {
    guard let level = selectedLevel else {
      topics = []
      return
    }
    topics = WordService.getTopics(for: level)
  }
  
  // MARK: - Private Methods
  
  /// Advances to the next word in the list by incrementing the current index.
  /// If the end of the list is reached, transitions to the summary screen with animation.
  private func selectNextCard() {
    if currentIndex < cards.count - 1 {
      currentIndex += 1
    } else {
      withAnimation { lessonState = .summary }
    }
  }
  
  /* 🍀 OLD 'selectNextCard' METHOD
  private func selectNextCard() {
    if currentIndex < cards.count - 1 {
      currentIndex += 1
    } else {
      let wordsStillToRepeat = cards
        .filter { unknownWords.contains($0.word) }
        .map { $0.word }
      
      if !wordsStillToRepeat.isEmpty {
        self.cards = wordsStillToRepeat.shuffled().map {
          Flashcard(id: $0.id, word: $0)
        }
        self.currentIndex = 0
      } else {
        withAnimation { lessonState = .summary }
      }
    }
  }
  */
}

// MARK: - Lesson State

extension FlashcardsViewModel {
  enum LessonState: Equatable, Hashable {
    case inProgress, summary
  }
}

// MARK: - Preview Mode

extension FlashcardsViewModel {
  static var previewMode: FlashcardsViewModel {
    let viewModel = FlashcardsViewModel()
    viewModel.selectedLevel = "B1.1"
    viewModel.selectedTopic = "Eating"
    viewModel.cards = [Flashcard(id: "1", word: Word.mock)]
    return viewModel
  }
}

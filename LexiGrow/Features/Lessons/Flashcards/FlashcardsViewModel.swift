//
//  FlashcardsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation
import SwiftUICore

@Observable
@MainActor
final class FlashcardsViewModel {
  
  // MARK: - Properties
  
  var lessonState: LessonState = .inProgress
  private(set) var lessonCards: [Flashcard] = []
  private(set) var currentIndex: Int = 0
  
  private(set) var knownWordsCount: Int = 0
  private(set) var repetitionWords: Set<Word> = []
  
  let levels: [String] = ["B1.1", "B1.2", "B2.1", "B2.2"]
  
  var selectedLevel: String?
  var selectedTopic: String?
  var availableTopics: [String] = []
  
  // MARK: - Computed Properties
  
  var currentCard: Flashcard? {
    guard lessonCards.indices.contains(currentIndex) else {
      return nil
    }
    return lessonCards[currentIndex]
  }
  
  // var currentCard: Flashcard? = Flashcard(id: "1", word: Word.mock)
  
  var progress: Double {
    guard !lessonCards.isEmpty else { return 0.0 }
    return Double(currentIndex + 1) / Double(lessonCards.count)
  }
  
  // MARK: - Init / Deinit
  
  init() { print("✅ FlashcardsViewModel initialized") }
  deinit { print("❌ FlashcardsViewModel deinitialized") }
  
  // MARK: - Public Methods
  
  func startLesson(level: String, topic: String) {
    let words = WordProvider.getWords(for: level, topic: topic)
    self.lessonCards = words.map {
      Flashcard(id: $0.id, word: $0)
    }
    self.currentIndex = 0
    self.knownWordsCount = 0
    self.repetitionWords.removeAll()
    self.lessonState = .inProgress
  }
  
  func handleKnown() {
    guard let card = currentCard else { return }
    
    if repetitionWords.contains(card.word) {
      repetitionWords.remove(card.word)
    } else {
      knownWordsCount += 1
    }
    selectNextCard()
  }
  
  func handleRepeat() {
    guard let card = currentCard else { return }
    repetitionWords.insert(card.word)
    selectNextCard()
  }
  
  func resetSetupSettings() {
    selectedLevel = nil
    selectedTopic = nil
  }
  
  func resetTopics() {
    guard let level = selectedLevel else {
      availableTopics = []
      return
    }
    availableTopics = WordProvider.getTopics(for: level)
  }
  
  // MARK: - Private Methods
  
  private func selectNextCard() {
    if currentIndex < lessonCards.count - 1 {
      currentIndex += 1
    } else {
      let wordsStillToRepeat = lessonCards
        .filter { repetitionWords.contains($0.word) }
        .map { $0.word }
      
      if !wordsStillToRepeat.isEmpty {
        self.lessonCards = wordsStillToRepeat.shuffled().map {
          Flashcard(id: $0.id, word: $0)
        }
        self.currentIndex = 0
      } else {
        withAnimation { lessonState = .summary }
      }
    }
  }
}

extension FlashcardsViewModel {
  enum LessonState: Equatable, Hashable {
    case inProgress, summary
  }
}

extension FlashcardsViewModel {
  static var previewMode: FlashcardsViewModel {
    let viewModel = FlashcardsViewModel()
    viewModel.selectedLevel = "B1.1"
    viewModel.selectedTopic = "Eating"
    return viewModel
  }
}

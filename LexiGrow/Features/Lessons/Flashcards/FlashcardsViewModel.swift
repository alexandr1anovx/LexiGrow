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
  
  var lessonState: LessonState = .inProgress
  private(set) var lessonCards: [Flashcard] = []
  private(set) var currentIndex: Int = 0
  
  private(set) var knownWordsCount: Int = 0
  private(set) var repetitionWords: Set<Word> = []
  
  // MARK: - Computed Properties
  
  var currentCard: Flashcard? {
    guard lessonCards.indices.contains(currentIndex) else {
      return nil
    }
    return lessonCards[currentIndex]
  }
  
  var progress: Double {
    guard !lessonCards.isEmpty else { return 0.0 }
    return Double(currentIndex + 1) / Double(lessonCards.count)
  }
  
  // MARK: - Init / Deinit
  
  // just for console output
  init() { print("FlashcardsViewModel initialized") }
  deinit { print("FlashcardsViewModel deinitialized") }
  
  // MARK: - Public Methods
  
  func startLesson(count: Int) {
    let words = WordProvider.getRandomWords(count: count)
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
  
  func resetLesson() {
    withAnimation { lessonState = .tryAgain }
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
    case inProgress, summary, tryAgain
  }
}

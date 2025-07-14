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
  
  enum LessonState: Equatable, Hashable {
    case selecting, inProgress, summary
  }
  
  var lessonState: LessonState = .selecting
  private(set) var lessonCards: [Flashcard] = []
  private(set) var currentIndex: Int = 0
  
  private(set) var knownWordsCount: Int = 0
  private(set) var repetitionWords: Set<Word> = []
  
  // MARK: Computed Properties
  
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
  
  init() {
    print("✅ FlashcardsViewModel initialized!")
  }
  
  deinit {
    print("❌ FlashcardsViewModel deinitialized!")
  }
  
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
    guard currentCard != nil else { return }
    if !repetitionWords.contains(where: { $0.id == currentCard?.word.id }) {
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
    lessonState = .selecting
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
        withAnimation {
          lessonState = .summary
        }
      }
    }
  }
}

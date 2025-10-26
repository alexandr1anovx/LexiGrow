//
//  CardsViewModelTests.swift
//  LexiGrowTests
//
//  Created by Alexander Andrianov on 18.09.2025.
//

import XCTest
@testable import LexiGrow

@MainActor
final class CardsViewModelTests: XCTestCase {

  func makeSUT() -> (CardsViewModel, SpyEducationService) {
    let spyEducationService = SpyEducationService()
    let vm = CardsViewModel(educationService: spyEducationService)
    return (vm, spyEducationService)
  }

  func test_canStartLesson_requiresLevelAndTopic() {
    let (vm, _) = makeSUT()
    XCTAssertFalse(vm.canStartLesson)

    vm.selectedLevel = .mockB1
    XCTAssertFalse(vm.canStartLesson)

    vm.selectedTopic = .mock1
    XCTAssertTrue(vm.canStartLesson)

    vm.resetSetupData()
    XCTAssertNil(vm.selectedLevel)
    XCTAssertNil(vm.selectedTopic)
    XCTAssertFalse(vm.canStartLesson)
  }

  func test_sortedTopics_ordersBySelectedOption() {
    let (vm, _) = makeSUT()
    vm.topics = [.mock1, .mock2, .mock3] // progress: 0.0, 0.5, 1.0

    vm.topicSortOption = .defaultOrder
    XCTAssertEqual(vm.sortedTopics.map(\.id), vm.topics.map(\.id))

    vm.topicSortOption = .uncompletedFirst
    XCTAssertEqual(vm.sortedTopics, [.mock1, .mock2, .mock3])

    vm.topicSortOption = .completedFirst
    XCTAssertEqual(vm.sortedTopics, [.mock3, .mock2, .mock1])

    vm.topicSortOption = .alphabeticalAZ
    XCTAssertEqual(vm.sortedTopics, vm.topics.sorted { $0.name < $1.name })
  }

  func test_lessonProgress_accuracy_and_feedback() {
    let (vm, _) = makeSUT()
    let words: [Word] = [.mock1, .mock2]
    vm._test_setWords(words, currentIndex: 0)
    vm._test_setLessonState(.inProgress)

    XCTAssertEqual(vm.lessonProgress, (0 + 1) / 3.0, accuracy: 0.0001)
    XCTAssertEqual(vm.lessonAccuracy, 0.0, accuracy: 0.0001)
    XCTAssertEqual(vm.lessonFeedbackTitle, "Keep Practicing!")
    XCTAssertEqual(vm.lessonFeedbackIconName, "figure.play.circle.fill")

    vm._test_appendKnown(words[0])
    vm._test_appendKnown(words[1])
    vm._test_setWords(words, currentIndex: 1)
    XCTAssertEqual(vm.lessonAccuracy, 2.0/3.0, accuracy: 0.0001)
    XCTAssertEqual(vm.lessonProgress, (1 + 1) / 3.0, accuracy: 0.0001)

    vm._test_setWords(words, currentIndex: 2)
    XCTAssertEqual(vm.lessonProgress, 1.0, accuracy: 0.0001)
    XCTAssertEqual(vm.lessonFeedbackTitle, "Excellent Work!")
    XCTAssertEqual(vm.lessonFeedbackIconName, "hands.clap.fill")
  }

  func test_handleKnownAndUnknown_advanceAndFinish() {
    let (vm, _) = makeSUT()
    let words: [Word] = [.mock1, .mock2]
    vm._test_setWords(words, currentIndex: 0)
    vm._test_setLessonState(.inProgress)

    XCTAssertEqual(vm.currentWord, .mock1)

    vm.handleKnownWord()
    XCTAssertEqual(vm.currentWord, .mock2)
    XCTAssertEqual(vm.knownWords, [.mock1])

    vm.handleUnknownWord()
    XCTAssertEqual(vm.lessonState, .summary)
    XCTAssertEqual(vm.unknownWords, [.mock2])
    XCTAssertNil(vm.currentWord)
  }

  func test_getLevels_callsServiceOnce_andStoresResult_orSetsError() async throws {
    let (vm, spy) = makeSUT()
    await vm.getLevels()
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertTrue(spy.getLevelsCalled)
    XCTAssertFalse(vm.levels.isEmpty)
    let firstCallLevels = vm.levels

    await vm.getLevels()
    try await Task.sleep(nanoseconds: 50_000_000)
    XCTAssertEqual(vm.levels, firstCallLevels)

    vm.levels = []
    spy.getLevelsError = NSError(domain: "test", code: 1)
    await vm.getLevels()
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertNotNil(vm.errorMessage)
  }

  func test_saveLessonProgress_propagatesServiceCall_andSetsErrorOnFailure() async throws {
    let (vm, spy) = makeSUT()
    vm._test_setWords([.mock1, .mock2])
    vm._test_appendKnown(.mock1)

    await vm.saveLessonProgress()
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertTrue(spy.saveLessonProgressCalled)

    spy.saveProgressError = NSError(domain: "test", code: 2)
    vm.errorMessage = nil
    await vm.saveLessonProgress()
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertNotNil(vm.errorMessage)
  }
}

// Test-only helpers to control private(set) state deterministically.
extension CardsViewModel {
  func _test_setWords(_ newWords: [Word], currentIndex: Int = 0) {
    self.words = newWords
    self.currentWordIndex = currentIndex
  }

  func _test_appendKnown(_ word: Word) {
    self.knownWords.append(word)
  }

  func _test_appendUnknown(_ word: Word) {
    self.unknownWords.append(word)
  }

  func _test_setLessonState(_ state: LessonState) {
    self.lessonState = state
  }
}

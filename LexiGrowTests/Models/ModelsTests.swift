//
//  ModelsTests.swift
//  LexiGrowTests
//
//  Created by Alexander Andrianov on 18.09.2025.
//

import XCTest
@testable import LexiGrow

final class ModelsTests: XCTestCase {
  
  func test_Topic_progressCalculation() {
    let zero = Topic(id: UUID(), name: "Zero", totalWords: 0, learnedWords: 0)
    XCTAssertEqual(zero.progress, 0.0)
    
    let half = Topic(id: UUID(), name: "Half", totalWords: 10, learnedWords: 5)
    XCTAssertEqual(half.progress, 0.5)
    
    let full = Topic(id: UUID(), name: "Full", totalWords: 4, learnedWords: 4)
    XCTAssertEqual(full.progress, 1.0)
  }
  
  func test_TopicSortOption_iconNames() {
    XCTAssertEqual(TopicSortOption.defaultOrder.iconName, "list.bullet")
    XCTAssertEqual(TopicSortOption.uncompletedFirst.iconName, "xmark.circle.fill")
    XCTAssertEqual(TopicSortOption.completedFirst.iconName, "checkmark.circle.fill")
    XCTAssertEqual(TopicSortOption.alphabeticalAZ.iconName, "textformat.abc")
  }
  
  func test_Lesson_typeMapping() {
    let flash = Lesson(id: UUID(), title: "Cards", subtitle: "", iconName: "x", isLocked: false)
    XCTAssertEqual(flash.type, .cards)
    
    let trans = Lesson(id: UUID(), title: "Translation", subtitle: "", iconName: "x", isLocked: false)
    XCTAssertEqual(trans.type, .translation)
    
    let other = Lesson(id: UUID(), title: "SomethingElse", subtitle: "", iconName: "x", isLocked: false)
    XCTAssertEqual(other.type, .unknown)
  }
  
  func test_LessonEntity_convenienceInit_fromDTO() {
    let dto = Lesson(id: UUID(), title: "Cards", subtitle: "Sub", iconName: "house", isLocked: true)
    let entity = LessonEntity(from: dto)
    XCTAssertEqual(entity.id, dto.id)
    XCTAssertEqual(entity.title, dto.title)
    XCTAssertEqual(entity.subtitle, dto.subtitle)
    XCTAssertEqual(entity.iconName, dto.iconName)
    XCTAssertEqual(entity.isLocked, dto.isLocked)
    XCTAssertEqual(entity.type, .cards)
  }
}

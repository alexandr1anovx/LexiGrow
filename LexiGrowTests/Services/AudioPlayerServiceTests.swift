//
//  AudioPlayerServiceTests.swift
//  LexiGrowTests
//
//  Created by Alexander Andrianov on 18.09.2025.
//

import XCTest
@testable import LexiGrow

final class AudioPlayerServiceTests: XCTestCase {

  func test_playSound_missingFile_setsErrorMessage() {
    let sut = AudioPlayerService()
    sut.playSound(named: "non_existent_file_123")
    XCTAssertEqual(sut.errorMessage, "Failed to find 'non_existent_file_123.mp3' file.")
  }
}

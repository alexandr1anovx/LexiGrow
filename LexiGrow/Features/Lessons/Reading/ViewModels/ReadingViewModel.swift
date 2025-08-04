//
//  ReadingViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 29.07.2025.
//

import SwiftUI

@MainActor
@Observable
final class ReadingViewModel {
  var topics: [String] = ["Travelling", "Sport", "Music"]
  var selectedTopic: String?
 
  init() {
    print("✅ Writing view model initialized!")
  }
  deinit {
    print("❌ Writing view model deinitialized!")
  }
  
  func startLesson() {
    
  }
}

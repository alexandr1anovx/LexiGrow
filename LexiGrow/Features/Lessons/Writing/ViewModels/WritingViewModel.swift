//
//  WritingViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 26.07.2025.
//

import SwiftUI

@MainActor
@Observable
final class WritingViewModel {
  var topics: [String] = ["Programming", "Travelling", "Sport", "Music"]
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

//
//  HomeViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.08.2025.
//

import Foundation

@Observable
@MainActor
final class StatisticsViewModel {
  
  private(set) var errorMessage: String?
  private(set) var isLoading = false
  private(set) var levelProgressData: [LevelProgress] = []
  private let supabaseService: SupabaseService
  
  init(supabaseService: SupabaseService) {
    self.supabaseService = supabaseService
  }
  
  func getLevelProgress() async {
    isLoading = true
    defer { isLoading = false }
    // check if there any progress data so not to make a repeat API call
    //guard levelProgressData.isEmpty else { return }
    
    // Temporary array for collecting results
    var tempProgressData: [LevelProgress] = []
    Task {
      do {
        let user = try await supabase.auth.user()
        let allLevels = try await supabaseService.getLevels()
        
        for level in allLevels {
          let topicProgressList = try await supabaseService.getTopicProgress(
            levelId: level.id,
            userId: user.id
          )
          // total words for level
          let totalWords = topicProgressList.reduce(0) { $0 + $1.totalWords }
          // learned words for level
          let learnedWords = topicProgressList.reduce(0) { $0 + $1.learnedWords }
          
          let progress = LevelProgress(
            id: level.id,
            name: level.name,
            orderIndex: level.orderIndex,
            totalWords: totalWords,
            learnedWords: learnedWords
          )
          tempProgressData.append(progress)
        }
        levelProgressData = tempProgressData
      } catch {
        errorMessage = "Failed to load level progress: \(error)"
      }
    }
  }
}

extension StatisticsViewModel {
  static var mockObject: StatisticsViewModel {
    let viewModel = StatisticsViewModel(supabaseService: SupabaseService.mockObject)
    return viewModel
  }
}

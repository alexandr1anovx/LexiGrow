//
//  HomeViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.08.2025.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class StatisticsViewModel {
  
  private(set) var errorMessage: String?
  private(set) var isLoading = false
  private let supabaseService: SupabaseService
  
  init(supabaseService: SupabaseService) {
    self.supabaseService = supabaseService
  }
  
  func syncProgress(context: ModelContext) async {
    isLoading = true
    defer { isLoading = false }
    do {
      let descriptor = FetchDescriptor<LevelProgress>()
      let localData = try context.fetch(descriptor)
      
      if localData.isEmpty {
        print("Local data is empty. Fetching from Supabase.")
        let remoteProgressData = try await fetchRemoteProgress()
        for remoteLevel in remoteProgressData {
          context.insert(remoteLevel)
        }
        try context.save()
        print("Local data successfully saved.")
        errorMessage = nil
      } else {
        print("Local data already exists. Skipping network fetch.")
      }
    } catch {
      errorMessage = "Failed to sync progress: \(error)"
    }
  }
  
  func fetchRemoteProgress() async throws -> [LevelProgress] {
    isLoading = true
    defer { isLoading = false }
    
    var tempProgressData: [LevelProgress] = []
    let user = try await supabase.auth.user()
    let allLevels = try await supabaseService.getLevels()
    
    for level in allLevels {
      let topicProgressList = try await supabaseService.getTopics(
        levelId: level.id,
        userId: user.id
      )
      // total topic words for level
      let totalWords = topicProgressList.reduce(0) { $0 + $1.totalWords }
      // learned topic words for level
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
    print("✅ Fetched remote progress data: \(tempProgressData)")
    return tempProgressData
  }
}

extension StatisticsViewModel {
  static var mockObject: StatisticsViewModel = {
    let viewModel = StatisticsViewModel(supabaseService: SupabaseService.mockObject)
    return viewModel
  }()
}

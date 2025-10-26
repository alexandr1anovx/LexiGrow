//
//  StatisticsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.08.2025.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class LessonProgressViewModel {
  
  private(set) var errorMessage: String?
  private(set) var isLoading = false
  private let educationService: EducationServiceProtocol
  
  init(educationService: EducationServiceProtocol) {
    self.educationService = educationService
  }
  
  /// Synchronizes progress. It fetches remote progress, compares it to local SwiftData,
  /// and only writes to SwiftData if there are changes (insert/update/delete).
  /// If there are no differences, it leaves the local store untouched.
  func syncProgress(context: ModelContext) async {
    isLoading = true
    defer { isLoading = false }
    do {
      // Load current local snapshot
      let localDescriptor = FetchDescriptor<LevelProgressEntity>()
      let localData = try context.fetch(localDescriptor)
      let localById = Dictionary(uniqueKeysWithValues: localData.map { ($0.id, $0) })
      
      // Compute remote snapshot
      let remoteData = try await fetchRemoteProgress()
      let remoteById = Dictionary(uniqueKeysWithValues: remoteData.map { ($0.id, $0) })
      
      // Detect differences
      var hasChanges = false
      
      // Upsert: insert new or update changed
      for remote in remoteData {
        if let local = localById[remote.id] {
          // Compare fields
          if local.name != remote.name ||
              local.orderIndex != remote.orderIndex ||
              local.totalWords != remote.totalWords ||
              local.learnedWords != remote.learnedWords {
            // Update local
            local.name = remote.name
            local.orderIndex = remote.orderIndex
            local.totalWords = remote.totalWords
            local.learnedWords = remote.learnedWords
            hasChanges = true
          }
        } else {
          // Insert missing
          context.insert(remote)
          hasChanges = true
        }
      }
      
      // Optional: remove local records that no longer exist remotely
      // (If your domain guarantees levels are stable, you can keep or remove this.)
      for local in localData {
        if remoteById[local.id] == nil {
          context.delete(local)
          hasChanges = true
        }
      }
      
      if hasChanges {
        try context.save()
        errorMessage = nil
        print("✅ Synced progress: changes detected and saved.")
      } else {
        print("✅ Synced progress: no changes detected; using local data.")
      }
    } catch {
      errorMessage = "Failed to sync progress: \(error)"
      print("❌ Failed to sync progress: \(error)")
    }
  }
  
  /// Always computes the latest progress from Supabase for all levels.
  /// Callers decide whether to persist based on comparison with local data.
  func fetchRemoteProgress() async throws -> [LevelProgressEntity] {
    isLoading = true
    defer { isLoading = false }
    
    var tempProgressData: [LevelProgressEntity] = []
    let user = try await SupabaseService.shared.client.auth.user()
    let allLevels = try await educationService.getLevels()
    
    for level in allLevels {
      let topicProgressList = try await educationService.getTopics(
        levelId: level.id,
        userId: user.id
      )
      // total topic words for level
      let totalWords = topicProgressList.reduce(0) { $0 + $1.totalWords }
      // learned topic words for level
      let learnedWords = topicProgressList.reduce(0) { $0 + $1.learnedWords }
      
      let progress = LevelProgressEntity(
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

extension LessonProgressViewModel {
  static var mock: LessonProgressViewModel = {
    let viewModel = LessonProgressViewModel(educationService: MockEducationService())
    return viewModel
  }()
}

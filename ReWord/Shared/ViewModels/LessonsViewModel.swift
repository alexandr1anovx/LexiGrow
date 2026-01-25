//
//  LessonsViewModel.swift
//  ReWord
//
//  Created by Alexander Andrianov on 05.08.2025.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class LessonsViewModel {
  // MARK: - Properties
  
  private(set) var lessons: [LessonEntity] = []
  private(set) var levels: [LevelProgressEntity] = []
  private(set) var isLoading = false
  private(set) var errorMessage: String?
  
  private let educationService: EducationServiceProtocol
  
  // MARK: - Init
  
  init(educationService: EducationServiceProtocol) {
    self.educationService = educationService
  }
  
  // MARK: - Local Data
  
  /// Loads lessons data from local storage.
  func fetchLocalLessons(context: ModelContext) {
    do {
      let descriptor = FetchDescriptor<LessonEntity>(sortBy: [SortDescriptor(\.title)])
      self.lessons = try context.fetch(descriptor)
      print("✅ Fetched \(lessons.count) lessons from local storage.")
    } catch {
      errorMessage = "Failed to fetch lessons from local storage: \(error.localizedDescription)"
      print("⚠️ Failed to fetch lessons from local storage: \(error)")
    }
  }
  
  // MARK: - Sync / Networking
  
  /// Synchronizes data from server with the local database.
  func syncData(context: ModelContext) async {
    isLoading = true
    errorMessage = nil
    defer { isLoading = false }
    
    do {
      let localDescriptor = FetchDescriptor<LessonEntity>()
      let localLessons = try context.fetch(localDescriptor)
      
      if localLessons.isEmpty {
        print("Local data is empty. Fetching data from server...")
        let remoteLessonsDTO = try await educationService.getLessons()
        print("Got the \(remoteLessonsDTO.count) lessons from server.")
        
        // Convert DTO into Entity and add to the context.
        for lessonDTO in remoteLessonsDTO {
          let lessonEntity = LessonEntity(from: lessonDTO)
          context.insert(lessonEntity)
        }
        try context.save()
        print("✅ New lessons successfully saved into local database.")
      } else {
        print("✅ Local data found. No network request is required.")
      }
      fetchLocalLessons(context: context)
    } catch {
      let errorDescription = "Sync error: \(error.localizedDescription)"
      errorMessage = errorDescription
      print("❌ \(errorDescription)")
    }
  }
}

// MARK: - Mocks / Preview

extension LessonsViewModel {
  static var mock: LessonsViewModel = {
    let viewModel = LessonsViewModel(educationService: MockEducationService())
    viewModel.lessons = [
      LessonEntity(
      id: UUID(),
      title: "Картки",
      subtitle: "Cards description Cards description Cards description Cards description",
      iconName: "house",
      isLocked: false
    ),
      LessonEntity(
        id: UUID(),
        title: "Переклад",
        subtitle: "Translation description",
        iconName: "house",
        isLocked: false
      )
    ]
    return viewModel
  }()
}

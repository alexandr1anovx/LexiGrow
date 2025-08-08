//
//  LessonsViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 05.08.2025.
//

import Foundation

@Observable
@MainActor
final class LessonsViewModel {
  
  private(set) var lessons: [Lesson] = []
  private(set) var isLoading = false
  private(set) var errorMessage: String?
  private let supabaseService: SupabaseService
  
  init(supabaseService: SupabaseService) {
    self.supabaseService = supabaseService
    Task { await fetchLessons() }
  }
  
  func fetchLessons() async {
    isLoading = true
    do {
      self.lessons = try await supabaseService.getLessons()
    } catch {
      errorMessage = "Failed to get lessons: \(error.localizedDescription)"
    }
    isLoading = false
  }
}

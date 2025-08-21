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
  private let supabaseService: SupabaseServiceProtocol
  
  init(supabaseService: SupabaseServiceProtocol) {
    self.supabaseService = supabaseService
  }
  
  func getLessons() async {
    isLoading = true
    defer { isLoading = false }
    // check if there any lessons data so not to make a repeat API call
    guard lessons.isEmpty else { return }
    do {
      self.lessons = try await supabaseService.getLessons()
    } catch {
      errorMessage = "Failed to get lessons: \(error)"
    }
  }
}

extension LessonsViewModel {
  static var mockObject: LessonsViewModel {
    let viewModel = LessonsViewModel(supabaseService: MockSupabaseService())
    return viewModel
  }
}

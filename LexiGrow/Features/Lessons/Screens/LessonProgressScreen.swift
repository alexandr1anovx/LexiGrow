//
//  LessonProgressScreen.swift
//  LexiGrow
//
//  Created by Oleksandr Andrianov on 19.11.2025.
//

import SwiftUI
import SwiftData

struct LessonProgressScreen: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(LessonProgressViewModel.self) var viewModel
  @Query(sort: \LevelProgressEntity.orderIndex)
  private var levelProgressData: [LevelProgressEntity]
  
  var body: some View {
    List(levelProgressData) {
      LessonProgressCell(
        title: $0.name,
        progress: $0.progress,
        learnedWords: $0.learnedWords,
        totalWords: $0.totalWords
      )
    }
    .listRowSpacing(8)
    .task {
      await viewModel.syncProgress(context: modelContext)
    }
  }
}

private struct LessonProgressCell: View {
  let title: String
  let progress: Double
  let learnedWords: Int
  let totalWords: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .font(.headline)
      ProgressView(value: progress)
        .progressViewStyle(.linear)
        .tint(.mainGreen)
      HStack(spacing: 3) {
        Text("Вивчено слів:")
        Text("\(learnedWords)")
          .foregroundStyle(.accent)
          .fontWeight(.semibold)
        Text("з")
        Text("\(totalWords)")
      }
      .font(.caption)
      .foregroundStyle(.secondary)
    }
  }
}

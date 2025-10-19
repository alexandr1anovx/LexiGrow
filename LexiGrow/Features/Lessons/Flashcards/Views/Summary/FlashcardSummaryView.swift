//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardSummaryView: View {
  @State private var selectedList: SelectedList?
  @State private var isFavorite = false
  @Environment(FlashcardViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  @State private var isVisible = false
  
  var body: some View {
    VStack(spacing: 30) {
      
      HStack(spacing: 15) {
        if isVisible {
          Image(systemName: isFavorite ? "checkmark.circle.dotted" : "app.background.dotted")
            .resizable()
            .frame(width: 35, height: 35)
            .contentTransition(.symbolEffect(.replace, options: .speed(0.6)))
            .foregroundStyle(.green)
        }
        Text(viewModel.lessonFeedbackTitle)
          .fontWeight(.bold)
          .font(.title)
      }
      .frame(height: 30)
      
      .onAppear {
        withAnimation { isVisible = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          withAnimation { isFavorite = true }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
          withAnimation { isVisible = false }
        }
      }
      
      ResultsRingView(score: viewModel.lessonAccuracy)
      
      HStack(spacing: 15) {
        StatCard("Known", viewModel.knownWords.count) {
          withAnimation(.easeInOut) { selectedList = .known }
        }
        StatCard("Unknown", viewModel.unknownWords.count) {
          withAnimation(.easeInOut) { selectedList = .unknown }
        }
        StatCard("Total", viewModel.words.count) {
          withAnimation(.easeInOut) { selectedList = .total }
        }
      }
      
      VStack(spacing: 10) {
        if #available(iOS 26, *) {
          Button {
            Task { await viewModel.startLesson() }
          } label: {
            Label("Repeat unknown words", systemImage: "")
              .modernLabelStyle()
          }
          .buttonStyle(.glass)
          Button {
            Task {
              await viewModel.saveLessonProgress()
              viewModel.resetSetupData()
              dismiss()
            }
          } label: {
            Label("Finish lesson", systemImage: "")
              .padding(12)
              .frame(maxWidth: .infinity)
              .fontWeight(.medium)
              //.modernLabelStyle(textColor: .blue)
          }
          .tint(.blue)
          .buttonStyle(.glassProminent)
        } else {
          Button {
            Task { await viewModel.startLesson() }
          } label: {
            Label("Repeat unknown words", systemImage: "")
              .prominentLabelStyle(tint: .purple)
          }
          Button {
            Task {
              await viewModel.saveLessonProgress()
              viewModel.resetSetupData()
              dismiss()
            }
          } label: {
            Label("Finish lesson", systemImage: "")
              .prominentLabelStyle(tint: .pink)
          }
        }
      }
    }
    .padding()
    .overlay {
      if let selectedList {
        WordListView(
          words: words(for: selectedList),
          onClose: {
            withAnimation(.easeInOut) {
              self.selectedList = nil
            }
          }
        ).transition(.scale.combined(with: .move(edge: .bottom)))
      }
    }
  }
}

// MARK: - Helpers

private extension FlashcardSummaryView {
  enum SelectedList {
    case known, unknown, total
  }
  
  func words(for list: SelectedList) -> [Word] {
    switch list {
    case .known: return viewModel.knownWords
    case .unknown: return viewModel.unknownWords
    case .total: return viewModel.words
    }
  }
}

// MARK: - Subviews

private extension FlashcardSummaryView {
  
  struct WordListView: View {
    let words: [Word]
    let onClose: () -> Void
    
    var body: some View {
      NavigationView {
        List(words) {
          Text("**\($0.original)** (\($0.translation))")
        }
        .padding(.top)
        .scrollContentBackground(.hidden)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: onClose) {
              Image(systemName: "xmark.circle.fill")
            }
          }
        }
      }
    }
  }
  
  struct ResultsRingView: View {
    let score: Double
    
    var body: some View {
      Gauge(value: score, in: 0...1) {
        Text("\(score * 100, specifier: "%.0f")%")
          .font(.title3)
          .fontWeight(.semibold)
      }
      .gaugeStyle(.accessoryCircularCapacity)
      .tint(.green)
      .scaleEffect(1.3)
      .padding(.vertical, 15)
    }
  }
  
  struct StatCard: View {
    let label: String
    let count: Int
    let onInfoTap: () -> Void
    
    init(_ label: String, _ count: Int, onInfoTap: @escaping () -> Void) {
      self.label = label
      self.count = count
      self.onInfoTap = onInfoTap
    }
    
    var body: some View {
      VStack(spacing: 6) {
        Text("\(count)")
          .font(.title2)
          .fontWeight(.bold)
        Text(label)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .frame(maxWidth: .infinity)
      .padding(10)
      .background(.thinMaterial)
      .clipShape(.rect(cornerRadius: 20))
      .overlay(alignment: .topTrailing) {
        Button(action: onInfoTap) {
          Image(systemName: "info.circle.fill")
            .font(.title3)
            .foregroundStyle(.orange)
        }
        .disabled(count == 0)
      }
    }
  }
}

#Preview {
  FlashcardSummaryView()
    .environment(FlashcardViewModel.mockObject)
}

//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardSummaryView: View {
  @State private var selectedList: SelectedList?
  @Environment(FlashcardViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    VStack(spacing: 30) {
      Text(viewModel.lessonFeedbackTitle)
        .fontWeight(.bold)
        .font(.title2)
        .fontDesign(.monospaced)
      
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
            viewModel.startLesson()
          } label: {
            Label("Repeat unknown words", systemImage: "")
              .modernLabelStyle()
          }
          .buttonStyle(.glass)
          Button {
            viewModel.saveLessonProgress()
            viewModel.resetSetupData()
            dismiss()
          } label: {
            Label("Finish lesson", systemImage: "")
              .modernLabelStyle(textColor: .pink)
          }
          .buttonStyle(.glass)
        } else {
          Button {
            viewModel.startLesson()
          } label: {
            Label("Repeat unknown words", systemImage: "")
              .prominentButtonStyle(tint: .purple)
          }
          Button {
            viewModel.saveLessonProgress()
            viewModel.resetSetupData()
            dismiss()
          } label: {
            Label("Finish lesson", systemImage: "")
              .prominentButtonStyle(tint: .pink)
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
          .fontDesign(.monospaced)
      }
      .gaugeStyle(.accessoryCircularCapacity)
      .tint(.green)
      .scaleEffect(1.5)
      .padding(.vertical, 25)
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
          .fontDesign(.monospaced)
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

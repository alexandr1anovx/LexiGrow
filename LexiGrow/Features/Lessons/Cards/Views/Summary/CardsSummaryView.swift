//
//  CardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct CardsSummaryView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(CardsViewModel.self) var viewModel
  @State private var wordSection: WordSection?
  
  var body: some View {
    ZStack {
      Color.mainBackground.ignoresSafeArea()
      
      VStack(spacing: 40) {
        Label {
          Text(viewModel.lessonFeedbackTitle)
            .fontWeight(.semibold)
            .font(.title2)
        } icon: {
          Image(systemName: viewModel.lessonFeedbackIconName)
            .font(.title)
            .foregroundStyle(.mainYellow)
        }
        
        HStack(spacing: 10) {
          StatItem("Known", viewModel.knownWords.count) {
            withAnimation(.easeInOut) { wordSection = .known }
          }
          StatItem("Unknown", viewModel.unknownWords.count) {
            withAnimation(.easeInOut) { wordSection = .unknown }
          }
          StatItem("Total", viewModel.words.count) {
            withAnimation(.easeInOut) { wordSection = .total }
          }
        }
        
        VStack(spacing: 10) {
          PrimaryLabelButton("Repeat unknown words", iconName: "repeat") {
            Task {
              await viewModel.startLesson()
            }
          }
          PrimaryButton("Finish lesson") {
            Task {
              await viewModel.saveLessonProgress()
              viewModel.resetSetupData()
              dismiss()
            }
          }
        }
      }
      .padding()
      .overlay {
        if let section = wordSection {
          WordList(
            words: getWords(for: section),
            onClose: {
              self.wordSection = nil
            }
          )
        }
      }
    }
  }
}

// MARK: - Subviews

extension CardsSummaryView {
  
  struct ResultsRing: View {
    let score: Double
    
    var body: some View {
      Gauge(value: score, in: 0...1) {
        Text("\(score * 100, specifier: "%.0f")%")
          .font(.title3)
          .fontWeight(.semibold)
      }
      .gaugeStyle(.accessoryCircularCapacity)
      .tint(.green)
      .scaleEffect(1.2)
    }
  }
  
  struct WordList: View {
    let words: [Word]
    let onClose: () -> Void
    
    var body: some View {
      NavigationView {
        List(words) {
          Text("**\($0.original)** - \($0.translation)")
        }
        .shadow(radius: 1)
        .scrollContentBackground(.hidden)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              withAnimation(.easeInOut) { onClose() }
            } label: {
              Image(systemName: "xmark.circle.fill")
            }
          }
        }
      }
    }
  }
  
  struct StatItem: View {
    let title: String
    let count: Int
    let onTap: () -> Void
    
    init(_ title: String, _ count: Int, onTap: @escaping () -> Void) {
      self.title = title
      self.count = count
      self.onTap = onTap
    }
    
    var body: some View {
      VStack(spacing: 8) {
        Text("\(count)")
          .font(.title2)
          .fontWeight(.bold)
        Text(title)
          .font(.caption)
      }
      .frame(maxWidth: .infinity)
      .padding(10)
      .background {
       Capsule()
          .fill(.systemGray)
          .shadow(radius: 2)
      }
      .overlay(alignment: .topTrailing) {
        Button(action: onTap) {
          Image(systemName: "info.circle.fill")
            .font(.title2)
            .foregroundStyle(.primary)
            //.symbolRenderingMode(.palette)
        }
        .opacity(count == 0 ? 0:1)
        .disabled(count == 0)
      }
    }
  }
}

// MARK: - Helpers

extension CardsSummaryView {
  
  enum WordSection: Identifiable {
    case known, unknown, total
    var id: Self { self }
  }
  
  func getWords(for section: WordSection) -> [Word] {
    switch section {
    case .known: return viewModel.knownWords
    case .unknown: return viewModel.unknownWords
    case .total: return viewModel.words
    }
  }
}

#Preview {
  CardsSummaryView()
    .environment(CardsViewModel.mock)
}

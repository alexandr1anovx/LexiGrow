//
//  FlashcardsSummaryView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardSummaryView: View {
  @Environment(FlashcardViewModel.self) var viewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text(viewModel.summaryTitle)
          .font(.title2)
          .fontWeight(.bold)
        
        ResultsRingView(score: viewModel.resultProgress)
        StatsDetailView(viewModel: viewModel)
        
        if !viewModel.unknownWords.isEmpty {
          UnknownWordsView(words: viewModel.unknownWords)
        }
        
        Spacer()
        
        VStack(spacing: 12) {
          RepeatUnknownWordsButton()
          RepeatWholeLessonButton()
          FinishButton {
            dismiss()
            viewModel.resetLevelAndTopic()
          }
        }
      }.padding()
    }
  }
}

// MARK: - Subviews

private extension FlashcardSummaryView {
  
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
      .scaleEffect(1.5)
      .padding(.vertical, 25)
    }
  }

  struct StatsDetailView: View {
    let viewModel: FlashcardViewModel
    
    var body: some View {
      HStack(spacing: 15) {
        StatCard(
          icon: "checkmark.circle.fill",
          count: viewModel.knownWords.count,
          label: "Known",
          iconColor: .green
        )
        StatCard(
          icon: "xmark.circle.fill",
          count: viewModel.unknownWords.count,
          label: "Unknown",
          iconColor: .red
        )
        StatCard(
          icon: "sum",
          count: viewModel.words.count,
          label: "Total",
          iconColor: .gray
        )
      }
    }
  }

  struct StatCard: View {
    let icon: String
    let count: Int
    let label: String
    let iconColor: Color
    
    var body: some View {
      VStack(spacing: 10) {
        Image(systemName: icon)
          .font(.title)
          .foregroundStyle(iconColor)
        Text("\(count)")
          .font(.title2)
          .fontWeight(.bold)
        Text(label)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(.thinMaterial)
      .clipShape(.rect(cornerRadius: 20))
      .shadow(radius: 2)
    }
  }

  struct UnknownWordsView: View {
    let words: [Word]
    
    var body: some View {
      DisclosureGroup("Review unknown words") {
        VStack(spacing: 10) {
          ForEach(Array(words.enumerated()), id: \.element) { index, word in
            Text("\(index + 1). \(word.original)")
              .fontWeight(.medium)
            if word != words.last {
              Divider()
            }
          }
        }.padding(.top, 10)
      }
      .padding()
      .background(.thinMaterial)
      .clipShape(.rect(cornerRadius: 20))
    }
  }
  
  struct RepeatUnknownWordsButton: View {
    @Environment(FlashcardViewModel.self) var viewModel
    
    var body: some View {
      Button {
        
      } label: {
        Label("Repeat unknown words", systemImage: "repeat")
          .frame(maxWidth: .infinity)
          .padding(12)
      }
      .borderedButtonStyle(tint: .purple)
    }
  }

  struct RepeatWholeLessonButton: View {
    @Environment(FlashcardViewModel.self) var viewModel
    
    var body: some View {
      Button {
        viewModel.startLesson()
      } label: {
        Label("Repeat the whole lesson", systemImage: "repeat")
          .frame(maxWidth: .infinity)
          .padding(12)
      }
      .borderedButtonStyle(tint: .orange)
    }
  }

  struct FinishButton: View {
    @Environment(FlashcardViewModel.self) var viewModel
    var finishAction: () -> Void
    
    var body: some View {
      Button(action: finishAction) {
        Label("Finish", systemImage: "flag.pattern.checkered")
          .frame(maxWidth: .infinity)
          .padding(12)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
}

// MARK: - Preview Mode

#Preview {
  FlashcardSummaryView()
    .environment(FlashcardViewModel.previewMode)
}

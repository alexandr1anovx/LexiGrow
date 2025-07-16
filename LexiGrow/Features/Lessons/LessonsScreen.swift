//
//  HomeScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

enum DisplayMode: String, Identifiable, CaseIterable {
  case blocks = "Blocks"
  case capsules = "Capsules"
  var id: Self { self }
}

struct LessonsScreen: View {
  @State private var displayMode: DisplayMode = .blocks
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.mainBackgroundColor.ignoresSafeArea()
        VStack {
          displayModeView
          TabView(selection: $displayMode) {
            LessonViewBlocks()
            LessonViewCapsules()
          }
          .tabViewStyle(.page)
          .onChange(of: displayMode) {
            feedbackGenerator.impactOccurred()
          }
        }
      }.navigationTitle("Lessons")
    }
  }
  
  // MARK: - Subviews
  
  private var displayModeView: some View {
    HStack(spacing: 15) {
      Text("Display Mode:")
        .fontWeight(.medium)
      displayModeSelector
    }
    .padding()
    .shadow(radius: 8)
  }
  
  private var displayModeSelector: some View {
    HStack(spacing: 8) {
      ForEach(DisplayMode.allCases) { mode in
        Button {
          displayMode = mode
          feedbackGenerator.impactOccurred()
        } label: {
          Text(mode.rawValue)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(displayMode == mode ? .white : .primary)
            .padding(4)
        }
        .tint(displayMode == mode ? .pink : .clear)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(
          .roundedRectangle(radius: 15)
        )
      }
    }
    .padding(8)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .stroke(
          LinearGradient(
            colors: [.pink, .orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 2
        )
        .fill(Color.cmSystem)
        
    )
  }
}

#Preview {
  LessonsScreen()
}

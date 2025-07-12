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
  @Environment(\.colorScheme) var colorScheme
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    NavigationView {
      VStack(spacing:15) {
        displayModeSelector
        TabView(selection: $displayMode) {
          LessonViewBlocks()
            .tag(DisplayMode.blocks)
          LessonViewCapsules()
            .tag(DisplayMode.capsules)
        }
        .tabViewStyle(.page)
        .onChange(of: displayMode) {
          feedbackGenerator.impactOccurred()
        }
      }
      .navigationTitle("Lessons")
    }
  }
  
  private var displayModeSelector: some View {
    HStack(spacing: 15) {
      Text("Display Mode:")
        .font(.callout)
        .fontWeight(.medium)
        .fontDesign(.rounded)
      viewOption
        .padding(7)
        .background(
          Capsule()
            .fill(Color.gradientOrangePink)
        )
    }
    .padding()
    .shadow(radius: 10)
  }
  
  private var viewOption: some View {
    HStack(spacing: 8) {
      ForEach(DisplayMode.allCases) { mode in
        Button {
          withAnimation { displayMode = mode }
          feedbackGenerator.impactOccurred()
        } label: {
          Text(mode.rawValue)
            .font(.subheadline)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(4)
        }
        .tint(displayMode == mode ? Color.primary.opacity(0.1) : Color.clear)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
      }
    }
  }
}

#Preview {
  LessonsScreen()
}

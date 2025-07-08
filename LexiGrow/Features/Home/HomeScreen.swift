//
//  HomeScreen.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct HomeScreen: View {
  @State private var displayMode: DisplayMode = .blocks
  @Environment(\.colorScheme) var colorScheme
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  var body: some View {
    NavigationView {
      VStack {
        displayModeSelector
        TabView(selection: $displayMode) {
          LessonViewBlocks().tag(DisplayMode.blocks)
          LessonViewCapsules().tag(DisplayMode.capsules)
        }
        .tabViewStyle(.page)
        .onChange(of: displayMode) {
          feedbackGenerator.impactOccurred()
        }
        .navigationTitle("Home")
      }
    }
  }
  
  private var displayModeSelector: some View {
    HStack(spacing:0) {
      Text("Display Mode:")
        .font(.callout)
        .fontWeight(.medium)
        .fontDesign(.rounded)
      viewOption
        .padding(6)
        .background(
          Capsule()
            .fill(Color.gradientOrangePink)
        )
        .clipShape(.capsule)
        .padding()
        .shadow(radius: 10)
    }
  }
  
  private var viewOption: some View {
    HStack(spacing: 8) {
      ForEach(DisplayMode.allCases, id: \.self) { mode in
        Button {
          withAnimation { displayMode = mode }
          feedbackGenerator.impactOccurred()
        } label: {
          Text(mode.title)
            .font(.subheadline)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .foregroundStyle(
              displayMode == mode ?  .white : .primary
            )
            .padding(10)
            .background(
              displayMode == mode ? Color.primary.opacity(0.2) : Color.clear
            )
            .clipShape(.capsule)
        }
      }
    }
  }
}

enum DisplayMode: String, CaseIterable {
  case blocks, capsules
  
  var title: String { rawValue.capitalized }
}




#Preview {
  HomeScreen()
}

extension Color {
  static var gradientOrangePink = LinearGradient(
    colors: [.orange.opacity(0.8), .pink.opacity(0.4)],
    startPoint: .leading,
    endPoint: .trailing
  )
}

//
//  LaunchView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct LaunchView: View {
  @State private var isAnimating: Bool = false
  
  var body: some View {
    Grid(verticalSpacing: 10) {
      GridRow {
        Text("Lexi")
          .foregroundStyle(isAnimating ? Color.primary : Color.clear)
          .opacity(isAnimating ? 1 : 0)
        Image(systemName: "globe")
          .foregroundStyle(isAnimating ? .clear : .blue)
          .symbolEffect(.pulse)
      }
      Divider()
        .gridCellUnsizedAxes(.horizontal)
      GridRow {
        Image(systemName: "brain.fill")
          .foregroundStyle(isAnimating ? .clear : .blue)
          .symbolEffect(.pulse)
        Text("Grow")
          .foregroundStyle(isAnimating ? Color.primary : Color.clear)
          .opacity(isAnimating ? 1 : 0)
      }
    }
    .font(.title2)
    .fontWeight(.semibold)
    .onAppear {
      withAnimation(.bouncy(duration: 1).repeatForever(autoreverses: true)) {
        isAnimating.toggle()
      }
    }
  }
}

#Preview {
  LaunchView()
}

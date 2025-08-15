//
//  LaunchView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct LaunchView: View {
  @State private var isAnimating = false
  
  var body: some View {
    Grid {
      GridRow {
        Text("Lexi")
          .foregroundStyle(isAnimating ? Color.primary : Color.clear)
          .opacity(isAnimating ? 1:0)
        Image(systemName: "globe")
          .foregroundStyle(isAnimating ? Color.clear : Color.blue)
      }
      Divider()
        .gridCellUnsizedAxes(.horizontal)
      GridRow {
        Image(systemName: "brain.fill")
          .foregroundStyle(isAnimating ? Color.clear : Color.blue)
        Text("Grow")
          .foregroundStyle(isAnimating ? Color.primary : Color.clear)
          .opacity(isAnimating ? 1:0)
      }
    }
    .font(.title2)
    .fontWeight(.semibold)
    .onAppear {
      withAnimation(.spring(duration: 0.8).repeatForever(autoreverses: true)) {
        isAnimating.toggle()
      }
    }
  }
}

#Preview {
  LaunchView()
}

//
//  MainGoalView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct MainGoalView: View {
  var body: some View {
    VStack(spacing: 10) {
      Text("Main Goal")
        .fontWeight(.semibold)
      Text("Reinforce your understanding and memorization of key concepts and information through active recall.")
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  MainGoalView()
}

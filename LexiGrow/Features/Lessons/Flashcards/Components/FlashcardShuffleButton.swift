//
//  ShuffleButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 16.07.2025.
//

import SwiftUI

struct FlashcardShuffleButton: View {
  var body: some View {
    Button {
      // add shuffle action
    } label: {
      Label("Shuffle", systemImage: "shuffle")
        .foregroundStyle(.cmSystem)
        .font(.title3)
        .fontWeight(.medium)
        .padding(11)
    }
    .tint(.cyan)
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.roundedRectangle(radius: 20))
    .shadow(radius: 8)
  }
}

#Preview {
  FlashcardShuffleButton()
}

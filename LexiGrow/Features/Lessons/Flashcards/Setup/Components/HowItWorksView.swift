//
//  HowItWorksView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct HowItWorksView: View {
  var body: some View {
    VStack(spacing: 10) {
      Text("How it works ?")
        .fontWeight(.semibold)
      Text("Each flashcard presents a question or a term on one side. Your task is to recall the answer or definition before flipping the card to reveal the correct information. Regularly reviewing these cards will strengthen your memory and help you retain information more effectively.")
        .font(.footnote)
        .foregroundStyle(.secondary)
        .padding(.horizontal,10)
    }
  }
}

#Preview {
  HowItWorksView()
}

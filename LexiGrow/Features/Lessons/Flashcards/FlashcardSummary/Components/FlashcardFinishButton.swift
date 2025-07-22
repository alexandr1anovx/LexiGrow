//
//  FlashcardFinishButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FlashcardFinishButton: View {
  var dismissAction: () -> Void
  
  var body: some View {
    Button(action: dismissAction) {
      Label("Finish", systemImage: "flag.pattern.checkered.2.crossed")
        .padding(11)
    }
    .prominentButtonStyle(tint: .pink)
  }
}

#Preview {
  FlashcardFinishButton {}
}

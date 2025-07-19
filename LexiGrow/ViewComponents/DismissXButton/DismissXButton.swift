//
//  DismissXButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct DismissXButton: View {
  var dismissAction: () -> Void
  
  var body: some View {
    Button(action: dismissAction) {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.pink)
    }
  }
}

#Preview {
  DismissXButton(dismissAction: {})
}

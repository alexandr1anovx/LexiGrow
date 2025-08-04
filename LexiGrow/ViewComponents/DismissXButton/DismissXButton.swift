//
//  DismissXButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct DismissXButton: View {
  var color: Color?
  var onDismiss: () -> Void
  
  var body: some View {
    Button(action: onDismiss) {
      Image(systemName: "xmark.circle.fill")
        .symbolRenderingMode(.hierarchical)
        .font(.title2)
        .foregroundStyle(color ?? .red)
    }
  }
}

#Preview {
  DismissXButton {}
}

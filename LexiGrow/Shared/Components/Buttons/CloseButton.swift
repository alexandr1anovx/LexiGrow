//
//  DismissXButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct CloseButton: View {
  var color: Color?
  var dismissAction: () -> Void
  
  var body: some View {
    Button(action: dismissAction) {
      if #available(iOS 26, *) {
        Image(systemName: "xmark.circle.fill")
      } else {
        Image(systemName: "xmark.circle.fill")
          .symbolRenderingMode(.hierarchical)
          .font(.title2)
          .foregroundStyle(color ?? .secondary)
      }
    }
  }
}

#Preview {
  CloseButton {}
}

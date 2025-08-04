//
//  ActionButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 01.08.2025.
//

import SwiftUI

extension FlashcardView {
  
  struct ActionButton: View {
    var title: String
    var systemImage: String
    var tint: Color
    var action: () -> Void
    
    var body: some View {
      Button(action: action) {
        Label(title, systemImage: systemImage)
          .padding(.vertical,12)
          .padding(.horizontal,4)
      }
      .prominentButtonStyle(tint: tint)
    }
  }
}

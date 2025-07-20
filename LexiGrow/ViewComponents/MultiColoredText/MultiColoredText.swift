//
//  MultiColoredText.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 17.07.2025.
//

import SwiftUI

struct MultiColoredText: View {
  let text: String
  
  private var middleIndex: String.Index {
    if !text.isEmpty {
      return text.index(text.startIndex, offsetBy: text.count / 2)
    } else {
      return text.index(text.startIndex, offsetBy: text.count)
    }
  }
  
  private var firstHalf: String.SubSequence {
    text[..<middleIndex]
  }
  private var secondHalf: String.SubSequence {
    text[middleIndex...]
  }
  
  var body: some View {
    Text(firstHalf)
    +
    Text(secondHalf)
      .foregroundStyle(.pink)
  }
}

#Preview {
  MultiColoredText(text: "Flashcards")
}

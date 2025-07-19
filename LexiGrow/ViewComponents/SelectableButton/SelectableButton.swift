//
//  SelectableButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.07.2025.
//

import SwiftUI

struct SelectableButton<Value: Equatable & CustomStringConvertible> : View {
  let content: Value
  @Binding var selectedContent: Value?
  let activeColor: Color
  let action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      Text(content.description)
        .font(.headline)
        .padding(15)
        .foregroundColor(.white)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedContent == content ? activeColor : .cmBlack)
            .stroke(selectedContent == content ? .clear : .white, lineWidth: 2)
        )
    }
  }
}

#Preview {
  SelectableButton(
    content: "Topic",
    selectedContent: .constant("Topic"),
    activeColor: .pink) {
      //
    }
}

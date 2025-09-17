//
//  SelectableButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 18.07.2025.
//

import SwiftUI

struct SelectableButton: View {
  let content: String
  @Binding var selectedContent: String?
  
  let activeColor: Color
  let inactiveColor: Color
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(content)
        .font(.callout)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .padding(15)
        .frame(minWidth: 55)
        .background {
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedContent == content ? activeColor : inactiveColor)
            .stroke(selectedContent == content ? .clear : .white, lineWidth: 2, antialiased: true)
        }
    }
    .animation(.easeInOut, value: selectedContent)
  }
}

//struct SelectableButton<Value: Equatable & CustomStringConvertible> : View {
//  let content: Value
//  @Binding var selectedContent: Value?
//  let activeColor: Color
//  let action: () -> Void
//
//  var body: some View {
//    Button {
//      action()
//    } label: {
//      Text(content.description)
//        .font(.callout)
//        .fontWeight(.medium)
//        .padding(15)
//        .foregroundColor(.white)
//        .background(
//          RoundedRectangle(cornerRadius: 20)
//            .fill(selectedContent == content ? activeColor : .black)
//            .stroke(selectedContent == content ? .clear : .white, lineWidth: 2)
//        )
//    }
//  }
//}

#Preview("Test Button") {
  @Previewable @State var selectedLevel: String? = "B1"
  let levels: [String] = ["A2", "B1", "B2"]
  
  ForEach(levels, id: \.self) { level in
    SelectableButton(
      content: level,
      selectedContent: $selectedLevel,
      activeColor: .pink,
      inactiveColor: .black) {
        selectedLevel = level
      }
  }
}

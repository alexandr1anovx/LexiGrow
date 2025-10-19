//
//  FlashcardLevelButton.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 15.08.2025.
//

import SwiftUI

struct LevelButton: View {
  let name: String
  @Binding var selectedLevel: Level?
  let selectAction: () -> Void
  
  var body: some View {
    Button(action: selectAction) {
      Text(name)
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(15)
        .background {
          Capsule()
            .fill(selectedLevel?.name == name ? .blue : .black)
            .stroke(
              selectedLevel?.name == name ? .clear : .systemGray,
              lineWidth: 2
            )
            .frame(minWidth: 55)
        }
    }
  }
}

#Preview {
  @Previewable @State var selectedLevel: Level?
  
  let levels: [Level] = [.mockB1, .mockB2]
  VStack {
    ScrollView(.horizontal) {
      HStack {
        ForEach(levels, id: \.id) { level in
          
          LevelButton(
            name: level.name,
            selectedLevel: $selectedLevel,
            selectAction: {
              selectedLevel = level
            }
          )
        }
      }.padding(4)
    }.scrollIndicators(.hidden)
  }
}

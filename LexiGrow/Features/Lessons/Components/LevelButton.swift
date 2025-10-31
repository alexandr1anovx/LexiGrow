//
//  LevelButton.swift
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
      ZStack {
        Capsule()
          .fill(selectedLevel?.name == name ? .mainBrown : .mainGreen)
          .stroke(
            selectedLevel?.name == name ? .mainGreen : .clear,
            lineWidth: 2
          )
          .frame(width: 55, height: 48)
        Text(name)
          .font(.subheadline)
          .foregroundColor(.white)
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
        ForEach(levels) { level in
          LevelButton(
            name: level.name,
            selectedLevel: $selectedLevel) {
              selectedLevel = level
            }
        }
      }.padding(3)
    }
    .scrollIndicators(.hidden)
    .shadow(radius: 1)
  }
}

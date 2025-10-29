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
      Text(name)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .padding(15)
        .background {
          Capsule()
            .fill(selectedLevel?.name == name ? .mainBrown : .mainGreen)
            .stroke(
              selectedLevel?.name == name ? .white : .clear,
              lineWidth: 2
            )
            .frame(width: 55)
        }
    }
  }
}

#Preview {
  @Previewable @State var selectedLevel: Level?
  
  let levels: [Level] = [.mockB1, .mockB2]
  VStack {
    ScrollView(.horizontal) {
      HStack(spacing: 18) {
        ForEach(levels) { level in
          LevelButton(
            name: level.name,
            selectedLevel: $selectedLevel) {
              selectedLevel = level
            }
        }
      }.padding(4)
    }
    .scrollIndicators(.hidden)
    .shadow(radius: 1)
  }
}

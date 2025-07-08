//
//  LessonViewBlocks.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import SwiftUI

struct LessonViewBlocks: View {
  
  private let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 18),
    GridItem(.flexible(), spacing: 18)
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(Lesson.lessons) { lesson in
          BlockView(lesson: lesson)
        }
      }
    }
    .shadow(
      color: .primary.opacity(0.8),
      radius: 0.5,
      x: 4, y: -3
    )
    .tag(DisplayMode.blocks)
    .padding()
    .shadow(radius: 5)
  }
}

struct BlockView: View {
  
  let lesson: Lesson
  @State private var isShownDescriptionPopover: Bool = false
  
  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: 20)
        .fill(lesson.color.gradient)
      
      VStack(alignment: .leading) {
        HStack {
          Text(lesson.name)
            .font(.headline)
            .fontDesign(.monospaced)
            .foregroundColor(.white)
          Spacer()
          Image(systemName: "lightbulb.circle.fill")
            .symbolRenderingMode(.hierarchical)
            .font(.title)
            .padding(.trailing, 10)
            .foregroundStyle(.white)
            .onTapGesture {
              isShownDescriptionPopover.toggle()
            }
        }
        .padding([.top, .leading], 12)
        Spacer()
      }
    }
    .frame(minHeight: 150)
    .popover(
      isPresented: $isShownDescriptionPopover,
      attachmentAnchor: .point(.top),
      arrowEdge: .bottom) {
        Text(lesson.description)
          .font(.footnote)
          .fontWeight(.medium)
          .foregroundStyle(.primary)
          .multilineTextAlignment(.leading)
          .presentationBackground(lesson.color.gradient.opacity(0.3))
          .presentationCompactAdaptation(.popover)
          .padding(.horizontal)
      }
  }
}

#Preview {
  LessonViewBlocks()
}

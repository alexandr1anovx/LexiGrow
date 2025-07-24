//
//  FreeLessonBlock.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct FreeLessonBlock: View {
  let lesson: Lesson
  @State var counter: Int = 0
  @State var origin: CGPoint = .zero
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 30)
        .fill(Color.green)
        .frame(width: 165, height: 150)
        .offset(x: 0, y: -7)
      
      RoundedRectangle(cornerRadius: 35)
        .fill(.white.tertiary)
        .stroke(.white, lineWidth: 2)
        .frame(width: 175, height: 150)
        .shadow(radius: 3)
      
      Text(lesson.name)
        .fontWeight(.bold)
        .fontDesign(.monospaced)
        .foregroundColor(.white)
        .padding(.horizontal)
    }
    .modifier(RippleEffect(at: origin, trigger: counter))
    .onPressingChanged { point in
      if let point {
        origin = point
        counter += 1
      }
    }
  }
}

#Preview {
  FreeLessonBlock(lesson: Lesson.mock)
}

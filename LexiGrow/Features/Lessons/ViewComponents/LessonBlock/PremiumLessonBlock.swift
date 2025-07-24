//
//  PremiumLessonBlock.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct PremiumLessonBlock: View {
  let lesson: Lesson
  @State var counter: Int = 0
  @State var origin: CGPoint = .zero
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 30)
        .fill(
          .pink
        )
        .frame(width: 165, height: 150)
        .offset(x: 0, y: -7)
      
      RoundedRectangle(cornerRadius: 35)
        .fill(.white.secondary)
        .stroke(.white, lineWidth: 2)
        .frame(width: 175, height: 150)
        .shadow(radius: 3)
        
        .onPressingChanged { point in
          if let point {
            origin = point
            counter += 1
          }
        }
        .modifier(
          RippleEffect(at: origin, trigger: counter)
        )
      VStack(spacing: 15) {
        Text(lesson.name)
          .fontWeight(.bold)
          .fontDesign(.monospaced)
        HStack {
          Image(.stars)
          Image(systemName: "lock.circle.dotted")
            .font(.title)
        }
      }.foregroundStyle(.white)
    }
  }
}

#Preview {
  PremiumLessonBlock(lesson: Lesson.mock)
}

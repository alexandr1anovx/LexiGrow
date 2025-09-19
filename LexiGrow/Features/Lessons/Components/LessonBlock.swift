//
//  LessonBlockView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 30.07.2025.
//

import SwiftUI

struct LessonBlock: View {
  let lesson: LessonEntity
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 30)
        .fill(.pink.gradient)
        .frame(width: 165, height: 150)
        .offset(x: 0, y: -5)
      
      if lesson.isLocked {
        RoundedRectangle(cornerRadius: 35)
          .fill(.white.secondary)
          .stroke(.white, lineWidth: 2)
          .frame(width: 175, height: 150)
          .shadow(radius: 3)
          .overlay(alignment: .topTrailing) {
            Image(systemName: "lock.circle.dotted")
              .font(.title)
              .padding(3)
              .foregroundStyle(.black)
              .background(Color.white)
              .clipShape(.circle)
          }
      } else {
        RoundedRectangle(cornerRadius: 35)
          .fill(.white.tertiary)
          .stroke(.white, lineWidth: 2)
          .frame(width: 175, height: 150)
          .shadow(radius: 3)
      }
      VStack(spacing: 15) {
        Text(lesson.title)
          .fontWeight(.bold)
          .fontDesign(.monospaced)
          .padding(.horizontal)
        Image(systemName: lesson.iconName)
      }
      .foregroundColor(.white)
    }
  }
}

#Preview {
  LessonBlock(lesson: LessonEntity.mockObject)
}

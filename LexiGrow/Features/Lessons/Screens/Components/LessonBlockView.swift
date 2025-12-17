//
//  LessonBlockView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 30.07.2025.
//

import SwiftUI

struct LessonBlockView: View {
  let lesson: LessonEntity
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 35)
        .fill(.mainGreen)
        .frame(width: 155, height: 140)
        .offset(x: 0, y: -5)
      
      if lesson.isLocked {
        RoundedRectangle(cornerRadius: 35)
          .fill(.white.secondary)
          .stroke(.white, lineWidth: 2)
          .frame(width: 175, height: 150)
          .shadow(radius: 2)
          .overlay(alignment: .topTrailing) {
            Image(systemName: "lock.circle.dotted")
              .font(.title)
              .padding(3)
              .foregroundStyle(.black)
              .background(.white)
              .clipShape(.circle)
          }
      } else {
        RoundedRectangle(cornerRadius: 35)
          .fill(.white.opacity(0.1))
          .stroke(.white, lineWidth: 2)
          .frame(width: 165, height: 140)
          .shadow(radius: 2)
      }
      VStack(spacing: 15) {
        Text(lesson.title)
          .fontWeight(.bold)
          .padding(.horizontal)
        Image(systemName: lesson.iconName)
          .font(.title2)
      }
      .foregroundColor(.white)
    }
  }
}

#Preview {
  LessonBlockView(lesson: LessonEntity.mock)
}

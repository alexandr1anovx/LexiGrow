//
//  PremiumLessonPreview.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 19.07.2025.
//

import SwiftUI

struct PremiumLessonPreview: View {
  let lesson: Lesson
  @Binding var selectedLessonForSheet: Lesson?
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      
      VStack(spacing: 40) {
        Spacer()
        DescriptionText(lesson: lesson)
        GetPremiumButton()
      }
      .presentationDetents([.fraction(0.33)])
      .presentationCornerRadius(50)
      .overlay(alignment: .topTrailing) {
        DismissXButton {
          selectedLessonForSheet = nil
        }.padding(20)
      }
    }
  }
}

private extension PremiumLessonPreview {
  
  struct DescriptionText: View {
    let lesson: Lesson
    
    var body: some View {
      VStack(spacing: 20) {
        Label {
          Text("\(lesson.name) is locked.")
            .font(.title2)
            .fontWeight(.bold)
        } icon: {
          Image(systemName: "lock.circle.dotted")
            .font(.title)
            .foregroundStyle(.pink)
        }
        Text("Get premium subscription to unlock this lesson.")
          .font(.callout)
          .fontWeight(.medium)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
    }
  }
  
  struct GetPremiumButton: View {
    var body: some View {
      Button {
        // action
      } label: {
        Label {
          HStack(spacing: 4) {
            Text("Subscribe for")
              .fontWeight(.semibold)
            Text("$4.99")
              .font(.headline)
              .fontWeight(.bold)
          }
        } icon: {
          Image(.stars)
        }
        .padding(11)
      }
      .prominentButtonStyle(tint: .pink)
    }
  }
}

#Preview {
  PremiumLessonPreview(
    lesson: Lesson.mock,
    selectedLessonForSheet: .constant(Lesson.mock)
  )
}

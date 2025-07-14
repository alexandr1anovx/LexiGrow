//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardsSetupView: View {
  
  // MARK: - Properties
  
  let lesson: Lesson // принимает выбранный урок (блок)
  @Bindable var viewModel: FlashcardsViewModel
  @Binding var selectedLessonForScreenCover: Lesson?
  
  @State private var selectedCount: Int?
  @Environment(\.dismiss) private var dismiss
  
  // MARK: - body
  
  var body: some View {
    VStack(spacing:15) {
      
      Text(lesson.name)
        .font(.title2)
        .fontWeight(.semibold)
        .padding(.top)
        
      Text(lesson.description)
        .font(.callout)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      
      Spacer()
      
      Text("How many words do you want to repeat?")
        .font(.headline)
      
      HStack {
        capsuleButton(for: 5)
        capsuleButton(for: 20)
        capsuleButton(for: 30)
      }
      
      Spacer()
      
      Button {
        viewModel.startLesson(count: selectedCount ?? 0)
        dismiss()
        selectedLessonForScreenCover = lesson
      } label: {
        Text("Start Lesson")
          .fontWeight(.medium)
          .padding(13)
      }
      .tint(Color.teal)
      .buttonBorderShape(.capsule)
      .buttonStyle(.bordered)
      .padding(.bottom)
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.height(280)])
    .presentationCornerRadius(50)
    .background(Color.cmBlack)
  }
  
  // MARK: - Subviews
  
  private func capsuleButton(for count: Int) -> some View {
    Button {
      if selectedCount == count {
        selectedCount = nil
      } else {
        selectedCount = count
      }
    } label: {
      Text("\(count)")
        .font(.subheadline)
        .fontWeight(.medium)
        .padding(.vertical, 13)
        .padding(.horizontal, 15)
        .foregroundColor(
          capsuleForeground(for: count)
        )
        .background(
          Circle()
            .fill(capsuleBackground(for: count))
            .stroke(
              capsuleBorder(for: count),
              lineWidth: 3
            )
        )
    }
  }
  
  private func capsuleForeground(for count: Int) -> Color {
    if selectedCount == count {
      return .blue
    } else {
      return .primary
    }
  }
  
  private func capsuleBackground(for count: Int) -> Color {
    if selectedCount == count {
      return .primary
    } else {
      return Color.clear
    }
  }
  
  private func capsuleBorder(for count: Int) -> AnyGradient {
    if selectedCount == count {
      return Color.clear.gradient
    } else {
      return lesson.color.gradient
    }
  }
}

#Preview {
  FlashcardsSetupView(
    lesson: Lesson.mock,
    viewModel: FlashcardsViewModel(),
    selectedLessonForScreenCover: .constant(.mock)
  )
}

//
//  FlashcardsSetupView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardsSetupView: View {
  let lesson: Lesson
  @Bindable var viewModel: FlashcardsViewModel
  @Binding var selectedLessonForFullScreenCover: Lesson?
  @State private var selectedWordCount: Int?
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      VStack(spacing: 30) {
        Spacer()
        lessonDescription
        wordCountOptions
        startLessonButton
      }
      .frame(maxHeight: .infinity)
      .overlay(alignment: .topTrailing) {
        dismissButton
      }
    }
  }
  
  // MARK: - Subviews
  
  private var dismissButton: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.pink)
    }.padding(.top)
  }
  
  private var lessonDescription: some View {
    VStack(spacing: 15) {
      Text(lesson.name)
        .font(.title)
        .fontWeight(.semibold)
      Text("How many words do you want to repeat?")
        .font(.callout)
    }
  }
  
  private func wordCountButton(count: Int) -> some View {
    Button {
      if selectedWordCount == count {
        selectedWordCount = nil
      } else {
        selectedWordCount = count
      }
    } label: {
      Text("\(count) words")
        .font(.headline)
        .padding(15)
        .foregroundColor(.white)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedWordCount == count ? .pink : .cmBlack)
            .stroke(selectedWordCount == count ? .clear : .white, lineWidth: 2)
            .shadow(radius: 10)
        )
    }
  }
  
  private var wordCountOptions: some View {
    HStack(spacing: 20) {
      wordCountButton(count: 5)
      wordCountButton(count: 20)
      wordCountButton(count: 30)
    }
  }
  
  private var startLessonButton: some View {
    Button {
      viewModel.startLesson(count: selectedWordCount!)
      selectedLessonForFullScreenCover = lesson
      dismiss()
    } label: {
      Text("Start Lesson")
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .padding(12)
    }
    .tint(.pink)
    .buttonBorderShape(.roundedRectangle(radius: 20))
    .buttonStyle(.borderedProminent)
    .shadow(radius: 8)
    .disabled(selectedWordCount == nil)
  }
}

#Preview {
  FlashcardsSetupView(
    lesson: Lesson.mock,
    viewModel: FlashcardsViewModel(),
    selectedLessonForFullScreenCover: .constant(.mock)
  )
}

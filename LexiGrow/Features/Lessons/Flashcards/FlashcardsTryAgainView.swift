//
//  FlashcardsTryAgainView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import SwiftUI

struct FlashcardsTryAgainView: View {
  @Bindable var viewModel: FlashcardsViewModel
  @State private var selectedCount: Int?
  var onDismiss: () -> Void
  
  var body: some View {
    ZStack {
      Color.mainBackgroundColor.ignoresSafeArea()
      VStack(spacing: 30) {
        Spacer()
        VStack(spacing: 15) {
          HStack {
            Text("Try")
            Text("Again!")
              .foregroundStyle(.pink)
          }
          .font(.title)
          .fontWeight(.semibold)
        }
        Text("How many words do you want to repeat?")
          .font(.headline)
        HStack(spacing: 20) {
          capsuleButton(for: 5)
          capsuleButton(for: 20)
          capsuleButton(for: 30)
        }
        Spacer()
        HStack(spacing: 20) {
          Button {
            onDismiss()
          } label: {
            Text("Return Home")
              .font(.headline)
              .foregroundStyle(.cmSystem)
              .padding(12)
          }
          .tint(.cmReversed)
          .buttonBorderShape(.roundedRectangle(radius: 20))
          .buttonStyle(.borderedProminent)
          .shadow(radius: 10)
          Button {
            viewModel.startLesson(
              count: selectedCount ?? 0
            )
          } label: {
            Text("Try again")
              .font(.headline)
              .foregroundStyle(.white)
              .padding(12)
          }
          .tint(.pink)
          .buttonBorderShape(.roundedRectangle(radius: 20))
          .buttonStyle(.borderedProminent)
          .disabled(selectedCount == nil)
          .shadow(radius: 10)
        }
      }.padding(.vertical)
    }
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
      Text("\(count) words")
        .font(.headline)
        .padding(15)
        .foregroundColor(.white)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(selectedCount == count ? .pink : .cmBlack)
            .stroke(selectedCount == count ? .clear : .white, lineWidth: 2)
            .shadow(radius: 10)
        )
    }
  }
}

#Preview {
  FlashcardsTryAgainView(
    viewModel: FlashcardsViewModel(),
    onDismiss: {}
  )
}

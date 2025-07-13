//
//  FlashcardsView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 13.07.2025.
//

import SwiftUI

struct FlashcardsView: View {
  @State private var isShowingExitSheet: Bool = false
  @State private var isFlipped: Bool = false
  @Environment(\.dismiss) var dismiss
  
  @State var cardCounter: Int = 0
  @State var cardOrigin: CGPoint = .zero
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.cmBlack
        .ignoresSafeArea()
        VStack(spacing: 10) {
          
          ZStack {
            cardFront
            cardBack
              .opacity(isFlipped ? 1:0)
          }
          .padding()
          .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
          )
          .onTapGesture {
            withAnimation(.spring(response: 1, dampingFraction: 0.7)) {
              isFlipped.toggle()
            }
          }
          Spacer()
          
          randomizeButton
            .padding(.vertical)
          
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              isShowingExitSheet = true
            } label: {
              Image(systemName: "xmark.circle.fill")
                .font(.title)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.pink)
            }
          }
        }
        .sheet(isPresented: $isShowingExitSheet) {
          ExitLessonView($isShowingExitSheet) {
            dismiss()
          }
        }
      }
    }
  }
  
  // MARK: - Subviews
  
  private var cardFront: some View {
    RoundedRectangle(cornerRadius: 40)
      .fill(
        LinearGradient(
          colors: [.teal, .green],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .onPressingChanged { point in
        if let point {
          cardOrigin = point
          cardCounter += 1
        }
      }
      .modifier(
        RippleEffect(
          at: cardOrigin,
          trigger: cardCounter
        )
      )
      .shadow(radius: 10)
      .overlay {
        VStack(spacing: 20) {
          Text("Word")
            .font(.largeTitle)
            .fontWeight(.semibold)
          Text("Transcription")
            .font(.title2)
            .fontWeight(.semibold)
        }
        .foregroundStyle(.white)
      }
  }
  
  private var cardBack: some View {
    RoundedRectangle(cornerRadius: 40)
      .fill(
        LinearGradient(
          colors: [.purple, .blue],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .shadow(radius: 10)
      .overlay {
        VStack {
          Spacer()
          Text("Translation")
            .font(.largeTitle)
            .fontWeight(.semibold)
          Spacer()
          HStack(spacing: 25) {
            repeatButton
            knowButton
          }.padding(.vertical)
        }
        .foregroundStyle(.white)
      }
      .rotation3DEffect(
        .degrees(180),
        axis: (x: 0.0, y: 1.0, z: 0.0)
      )
  }
  
  private var randomizeButton: some View {
    Button {
      
    } label: {
      Label("Randomize", systemImage: "arrow.trianglehead.2.counterclockwise")
        .font(.title3)
        .fontWeight(.medium)
        .padding(10)
    }
    .tint(.blue)
    .buttonStyle(.bordered)
    .buttonBorderShape(.capsule)
    .shadow(radius: 8)
  }
  
  private var knowButton: some View {
    Button {
      
    } label: {
      Label("Know", systemImage: "checkmark.seal.fill")
        .font(.title3)
        //.foregroundStyle(.white)
        .fontWeight(.medium)
        .padding(10)
    }
    .tint(.teal)
    .buttonStyle(.bordered)
    .buttonBorderShape(.capsule)
    .shadow(radius: 8)
  }
  
  private var repeatButton: some View {
    Button {
      
    } label: {
      Label("Repeat", systemImage: "repeat")
        .font(.title3)
        //.foregroundStyle(.white)
        .fontWeight(.medium)
        .padding(11)
    }
    .tint(.teal)
    .buttonStyle(.bordered)
    .buttonBorderShape(.capsule)
    .shadow(radius: 8)
  }
}

#Preview {
  FlashcardsView()
}

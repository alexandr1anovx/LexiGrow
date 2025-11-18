//
//  LaunchView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct LaunchScreen: View {
  enum LoadingState {
    case start, end
    
    var next: LoadingState {
      switch self {
      case .start: return .end
      case .end: return .start
      }
    }
  }
  
  @State private var currentState: LoadingState = .start
  @State private var isContentReady = false
  
  var body: some View {
    VStack {
      HStack {
        Circle()
          .fill(.mainBrown)
          .frame(width: 20, height: 20)
          .scaleEffect(currentState == .start ? 1 : 0.3)
          .opacity(currentState == .start ? 1 : 0)
        Circle()
          .fill(.mainGreen)
          .frame(width: 20, height: 20)
          .scaleEffect(currentState == .end ? 1 : 0.3)
          .opacity(currentState == .end ? 1 : 0)
      }
    }
    .onAppear(perform: startAnimation)
  }
  
  private func startAnimation() {
    guard !isContentReady else { return }
    withAnimation { currentState = currentState.next }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      startAnimation()
    }
  }
}

#Preview {
  LaunchScreen()
}

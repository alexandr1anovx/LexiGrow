//
//  OnboardingScreen.swift
//  ReWord
//
//  Created by Alexander Andrianov on 27.10.2025.
//

import SwiftUI
import Lottie

// MARK: - Onboarding Screen

struct OnboardingScreen: View {
  @State private var currentPage: OnboardingPage = .welcome
  var onComplete: () -> Void
  
  var body: some View {
    ZStack {
      if currentPage == .getStarted {
        Color.onboardingLastPageBackground.ignoresSafeArea()
      } else {
        Color.system.ignoresSafeArea()
      }
      
      VStack {
        Button("Пропустити") {
          currentPage = .getStarted
        }
        .tint(.gray)
        .font(.subheadline)
        .underline()
        .padding(.top)
        .opacity(currentPage == .getStarted ? 0:1)
        .frame(maxWidth: .infinity, alignment: .trailing)
        
        Spacer()
        OnboardingPageView(page: currentPage)
          .transition(.blurReplace)
          .id(currentPage)
        Spacer()
        
        AnimatableButton(currentPage == .getStarted ? "Почати подорож" : "Далі") {
          goToNextPage()
        }
        .sensoryFeedback(.impact, trigger: currentPage)
      }
      .padding(20)
      .animation(.spring, value: currentPage)
    }
  }
  
  private func goToNextPage() {
    if currentPage == .getStarted {
       onComplete()
    } else {
      if let currentIndex = OnboardingPage.allCases.firstIndex(of: currentPage) {
        let nextIndex = currentIndex + 1
        if nextIndex < OnboardingPage.allCases.count {
          currentPage = OnboardingPage.allCases[nextIndex]
        }
      }
    }
  }
}

// MARK: - Onboarding Page View

private struct OnboardingPageView: View {
  var page: OnboardingPage
  
  var body: some View {
    VStack(spacing: 20) {
      
      LottieView(animation: .named(page.animationName))
        .playbackMode(.playing(.toProgress(1, loopMode: page == .getStarted ? .playOnce : .loop)))
        .frame(width: 200, height: 200)
      
      VStack(spacing: 20) {
        Text(page.title)
          .font(.title)
          .fontWeight(.bold)
          .foregroundStyle(page == .getStarted ? .white : .mainGreen)
        Text(page.description)
          .multilineTextAlignment(.center)
          .foregroundColor(page == .getStarted ? .white : .primary)
      }
    }
  }
}

// MARK: - Onboarding Page

private enum OnboardingPage: CaseIterable, Identifiable {
  case welcome
  case learnWithCards
  case trackYourProgress
  case getStarted
  
  var id: Self { self }
  
  var animationName: String {
    switch self {
    case .welcome: "Welcome"
    case .learnWithCards: "CardsSwap"
    case .trackYourProgress: "Progress"
    case .getStarted: "Success"
    }
  }
  
  var title: String {
    switch self {
    case .welcome: "Привіт!"
    case .learnWithCards: "Вивчай слова легко"
    case .trackYourProgress: "Відстежуй свій прогрес"
    case .getStarted: "Ну що, поїхали?"
    }
  }
  
  var description: String {
    switch self {
    case .welcome:
      "Я - Rewo, допоможу тобі досягти мовних цілей ефективно та з задоволенням."
    case .learnWithCards:
      "Обирай цікаві теми та запам'ятовуй нові слова за допомогою карток."
    case .trackYourProgress:
      "Слідкуй за кількістю вивчених слів та покращуй свої результати щодня."
    case .getStarted:
      "Давай налаштуємо твій профіль та оберемо першу тему для вивчення!"
    }
  }
}

#Preview {
  OnboardingScreen {}
}

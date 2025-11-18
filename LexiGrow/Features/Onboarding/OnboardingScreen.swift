//
//  OnboardingScreen.swift
//  LexiGrow
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
        Color.primary.ignoresSafeArea()
      }
      
      VStack {
        Button("Пропустити") {
          currentPage = .getStarted
        }
        .font(.footnote)
        .capsuleLabelStyle()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .opacity(currentPage == .getStarted ? 0 : 0.5)
        .padding(.trailing)
        
        Spacer()
        
        OnboardingPageView(page: currentPage)
          .transition(.blurReplace)
          .id(currentPage)
        
        Spacer()
        
        AnimatableButton(currentPage == .getStarted ? "Почати подорож" : "Далі") {
          handleNextButton()
        }
        .sensoryFeedback(.impact, trigger: currentPage)
        .padding(20)
      }
      .animation(.easeInOut, value: currentPage)
    }
  }
  
  private func handleNextButton() {
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

extension OnboardingScreen {
  struct OnboardingPageView: View {
    var page: OnboardingPage
    
    var body: some View {
      VStack(spacing: 20) {
        
        LottieView(animation: .named(page.imageName))
          .playbackMode(.playing(.toProgress(1, loopMode: page == .getStarted ? .playOnce : .loop)))
          .frame(width: 250, height: 200)
        
        VStack(spacing: 20) {
          Text(page.title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(page == .getStarted ? Color.whiteGradient : Color.yellowGreenGradient)
          Text(page.description)
            .multilineTextAlignment(.center)
            .foregroundColor(page == .getStarted ? .white : .secondary)
        }
      }.padding(.horizontal, 30)
    }
  }
}

// MARK: - Onboarding Page

extension OnboardingScreen {
  enum OnboardingPage: CaseIterable, Identifiable {
    case welcome
    case learnWithCards
    case trackYourProgress
    case getStarted
    
    var id: Self { self }
    
    var imageName: String {
      switch self {
      case .welcome: "Welcome"
      case .learnWithCards: "CardsSwap"
      case .trackYourProgress: "Progress"
      case .getStarted: "Success"
      }
    }
    
    var title: String {
      switch self {
      case .welcome: "Привіт! 😊"
      case .learnWithCards: "Вивчай слова легко 😎"
      case .trackYourProgress: "Відстежуй прогрес 🧐"
      case .getStarted: "Ну що, поїхали?"
      }
    }
    
    var description: String {
      switch self {
      case .welcome:
        "Lexi допоможе тобі досягти мовних цілей ефективно та з задоволенням."
      case .learnWithCards:
        "Обирай цікаві теми та запам'ятовуй нові слова за допомогою карток."
      case .trackYourProgress:
        "Слідкуй за кількістю вивчених слів та покращуй свої результати щодня."
      case .getStarted:
        "Давай налаштуємо твій профіль та оберемо першу тему для вивчення!"
      }
    }
  }
}

#Preview {
  OnboardingScreen {}
}

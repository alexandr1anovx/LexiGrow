//
//  AuthError.swift
//  ReWord
//
//  Created by Oleksandr Andrianov on 01.12.2025.
//

import Foundation

enum AuthError: LocalizedError, Identifiable {
  case invalidCredentials
  case networkError(description: String)
  case serverError
  case emailNotConfirmed
  case userAlreadyExists
  case unknown(description: String)
  
  var id: String { self.localizedDescription }
  
  var title: String {
    switch self {
    case .invalidCredentials:
      "Помилка входу"
    case .networkError:
      "Помилка мережі"
    case .serverError:
      "Помилка сервера"
    case .emailNotConfirmed:
      "Email не підтверджено"
    case .userAlreadyExists:
      "Користувач вже існує"
    case .unknown:
      "Невідома помилка"
    }
  }
  
  var message: String {
    switch self {
    case .invalidCredentials:
      "Неправильна пошта або пароль. Будь ласка, перевірте дані та спробуйте ще раз."
    case .networkError(let description):
      "Перевірте ваше інтернет-з'єднання. Деталі: \(description)"
    case .serverError:
      "На жаль, сталася помилка на нашому боці. Спробуйте, будь ласка, пізніше."
    case .emailNotConfirmed:
      "Будь ласка, перевірте свою пошту та перейдіть за посиланням для активації акаунту."
    case .userAlreadyExists:
      "Акаунт з такою поштою вже зареєстровано. Будь ласка, увійдіть."
    case .unknown(let description):
      "Сталася неочікувана помилка: \(description)"
    }
  }
}

//
//  GuessTheContextViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.07.2025.
//

import SwiftUICore
import GoogleGenerativeAI

struct Answer: Codable, Identifiable, Equatable {
  let id = UUID()
  let text: String
}

struct ContextLesson: Codable {
  let topic: String
  let text: String
  let answers: [Answer]
  let correctAnswerIndex: Int
}

@MainActor
@Observable
final class GuessTheContextViewModel {
  
  var errorMessage: String?
  var selectedContext: String? // для setup view
  var isLoading: Bool = false
  var lessonState: LessonState = .inProgress
  
  //var lesson: ContextLesson?
  var tasks: [ContextLesson] = []
  var currentIndex: Int = 0
  var correctAnswersCount: Int = 0
  var contexts: [String] = ["Programming", "Travelling", "Sport", "Music"]
  
  private var generativeModel: GenerativeModel?
  
  // MARK: - Computed Properties
  
  func buttonColor(answer: Answer) -> Color {
    guard let task = currentTask else {
      return .cmBlack
    }
    if let selectedIndex = task.answers.firstIndex(where: { $0.id == answer.id }) {
      return selectedIndex == task.correctAnswerIndex ? .green : .red
    } else {
      return .cmBlack
    }
  }
  
  var currentTask: ContextLesson? {
    guard tasks.indices.contains(currentIndex) else {
      return nil
    }
    return tasks[currentIndex]
  }
   
  var progress: Double {
    guard !tasks.isEmpty else { return 0.0 }
    return Double(currentIndex) / Double(tasks.count)
  }
  
  // MARK: - Init / Deinit
  
  init() {
    setupModel()
  }
  
  // MARK: - Public Methods
  
  func startNewLesson(context: String) {
    self.tasks = []
    self.currentIndex = 0
    self.correctAnswersCount = 0
    self.lessonState = .inProgress
    self.isLoading = true
    self.errorMessage = nil
    
    Task {
      await generateTasks(for: context)
    }
  }
  
  func selectAnswer(_ answer: Answer) {
    guard let task = currentTask else { return }
    if let selectedIndex = task.answers.firstIndex(where: { $0.id == answer.id }) {
      if selectedIndex == task.correctAnswerIndex {
        correctAnswersCount += 1
      }
    }
    goToNextTask()
  }
  
  private func goToNextTask() {
    if currentIndex < tasks.count - 1 {
      currentIndex += 1
    } else {
      lessonState = .summary
    }
  }
  
  private func generateTasks(for context: String) async {
    guard let model = generativeModel else {
      errorMessage = "The model is not initialized."
      isLoading = false
      return
    }
    
    let prompt = createPromptForTasks(for: context)
    
    do {
      let response = try await model.generateContent(prompt)
      guard let text = response.text else {
        errorMessage = "Received a blank response from AI."
        isLoading = false
        return
      }
      
      if let data = text.data(using: .utf8) {
        let decoder = JSONDecoder()
        self.tasks = try decoder.decode([ContextLesson].self, from: data)
      }
      
    } catch {
      errorMessage = "An error occurred while generating the lesson: \(error.localizedDescription)"
      print(error.localizedDescription)
    }
    
    isLoading = false
  }
  
  func startLesson(context: String) {
    self.currentIndex = 0
    self.lessonState = .inProgress
  }
  
  private func createPromptForTasks(for context: String) -> String {
    return """
          Сгенерируй урок по английскому языку на тему "\(context)" для уровня Intermediate.
          Урок должен состоять из 5 заданий.
          
          В ответе должен быть JSON-массив, содержащий 5 объектов. Каждый объект должен соответствовать структуре:
          {
            "topic": "\(context)",
            "text": "Короткий текст (3-4 предложения) на английском с пропущенным словом или фразой.",
            "answers": [
              {"text": "Вариант ответа 1"},
              {"text": "Вариант ответа 2"},
              {"text": "Вариант ответа 3"},
              {"text": "Вариант ответа 4"}
            ],
            "correctAnswerIndex": "индекс (от 0 до 3) правильного ответа"
          }
          
          Убедись, что ответ является валидным JSON-массивом из 5 таких элементов.
          """
  }
  
  private func setupModel() {
    let apiKey = "AIzaSyAvp16KVd9zRoKbyBPHtRYgkNDxSZZRR6Q"
    let config = GenerationConfig(responseMIMEType: "application/json")
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: apiKey, generationConfig: config)
    self.generativeModel = model
  }
}

// MARK: Lesson State

extension GuessTheContextViewModel {
  enum LessonState: Equatable, Hashable {
    case inProgress, summary
  }
}

extension GuessTheContextViewModel {
  static var previewMode: GuessTheContextViewModel {
    let viewModel = GuessTheContextViewModel()
    viewModel.selectedContext = "Programming"
    return viewModel
  }
}

//
//  GuessTheContextViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 22.07.2025.
//

import SwiftUICore
import GoogleGenerativeAI

struct Answer: Codable, Identifiable, Equatable {
  let id: String
  let text: String
  
  private enum CodingKeys: String, CodingKey {
    case text
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.text = try container.decode(String.self, forKey: .text)
    self.id = UUID().uuidString
  }
  
  init(id: String = UUID().uuidString, text: String) {
    self.id = id
    self.text = text
  }
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
  var lessonState: LessonState = .inProgress
  
  var isLoading = false
  var errorMessage: String?
  var selectedLevel: String?
  var selectedContext: String?
  var selectedAnswerID: String? = nil
  
  var tasks: [ContextLesson] = []
  var currentIndex: Int = 0
  var correctAnswersCount: Int = 0
  //var contexts: [String] = ["Programming", "Travelling", "Sport", "Music"]
  
  private var generativeModel: GenerativeModel?
  
  // MARK: - Computed Properties
  
  func buttonColor(answer: Answer) -> Color {
    guard let task = currentTask else {
      return .black
    }
    // If no answer is selected, all buttons are black
    guard let selectedID = selectedAnswerID else {
      return .black
    }
    // If this is the selected answer, show green/red
    if answer.id == selectedID {
      return task.correctAnswerIndex == task.answers.firstIndex(where: { $0.id == answer.id }) ? .green : .red
    }
    // All other buttons remain black
    return .black
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
  
  func startLesson() {
    self.currentIndex = 0
    self.lessonState = .inProgress
  }
  
  func endLesson() {
    self.tasks = []
    self.currentIndex = 0
    self.correctAnswersCount = 0
    self.selectedContext = nil
    self.isLoading = false
    self.errorMessage = nil
  }
  
  func startNewLesson() {
    self.tasks = []
    self.currentIndex = 0
    self.correctAnswersCount = 0
    self.lessonState = .inProgress
    self.isLoading = true
    self.errorMessage = nil
    Task {
      await generateTasks(for: selectedContext!, level: "B1")
    }
  }
  
  func selectAnswer(_ answer: Answer) {
    selectedAnswerID = answer.id
    guard let task = currentTask else { return }
    if let selectedIndex = task.answers.firstIndex(where: { $0.id == answer.id }) {
      if selectedIndex == task.correctAnswerIndex {
        correctAnswersCount += 1
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.goToNextTask()
    }
  }
  
  private func goToNextTask() {
    if currentIndex < tasks.count - 1 {
      currentIndex += 1
    } else {
      withAnimation {
        lessonState = .summary
      }
    }
  }
  
  private func generateTasks(for context: String, level: String) async {
    guard let model = generativeModel else {
      errorMessage = "The model is not initialized."
      isLoading = false
      return
    }
    
    let prompt = createPromptForTasks(for: context, level: level)
    
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
      errorMessage = "An error occurred while generating the lesson: \(error)"
      print(error)
    }
    
    isLoading = false
  }
  
  
  
  private func createPromptForTasks(for context: String, level: String) -> String {
    return """
             Сгенерируй урок по английскому языку на тему "\(context)" для уровня "\(level)".
             Урок должен состоять из 5 заданий.
             В ответе должен быть ТОЛЬКО валидный JSON-массив, содержащий 5 объектов. Не добавляй никаких пояснений или ```json.
             Каждый объект должен соответствовать структуре:
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
             """
  }
  
  private func setupModel() {
    let apiKey = APIKey.default
    let config = GenerationConfig(responseMIMEType: "application/json")
    let model = GenerativeModel(name: "gemini-2.0-flash", apiKey: apiKey, generationConfig: config)
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

//
//  SpeechService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 20.09.2025.
//

import Foundation
import AVFoundation

protocol SpeechServiceProtocol: AnyObject {
  var isSpeaking: Bool { get }
  var languageCode: String { get set }
  var rate: Float { get set }
  var pitch: Float { get set }
  func speak(text: String)
  func stop(immediately: Bool)
}

final class SpeechService: NSObject, SpeechServiceProtocol {
  private let synthesizer = AVSpeechSynthesizer()
  
  var languageCode: String
  var rate: Float // 0.0...1.0 user scale; will map to AVSpeechUtteranceDefaultSpeechRate-based value
  var pitch: Float // 0.5...2.0
  
  private(set) var isSpeaking: Bool = false
  
  // MARK: - Init
  
  init(languageCode: String = "en-US", rate: Float = 0.3, pitch: Float = 0.5) {
    self.languageCode = languageCode
    self.rate = rate
    self.pitch = pitch
    super.init()
    configureAudioSession()
  }
  
  // MARK: - Public
  
  func speak(text: String) {
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    
    // Map user rate [0,1] to AVSpeechUtterance rate range around default
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
    let base = AVSpeechUtteranceDefaultSpeechRate
    // Allow slower/faster within safe bounds
    let minRate = max(AVSpeechUtteranceMinimumSpeechRate, base - 0.15)
    let maxRate = min(AVSpeechUtteranceMaximumSpeechRate, base + 0.25)
    utterance.rate = minRate + (maxRate - minRate) * rate
    utterance.pitchMultiplier = max(0.5, min(2.0, pitch))
    utterance.preUtteranceDelay = 0.0
    utterance.postUtteranceDelay = 0.0
    
    synthesizer.speak(utterance)
  }
  
  func stop(immediately: Bool) {
    if immediately {
      synthesizer.stopSpeaking(at: .immediate)
    } else {
      synthesizer.stopSpeaking(at: .word)
    }
  }
  
  // MARK: - AVSpeechSynthesizerDelegate
  
//  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
//    isSpeaking = true
//  }
//  
//  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//    isSpeaking = false
//  }
//  
//  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//    isSpeaking = false
//  }
  
  // MARK: - Audio Session
  
  private func configureAudioSession() {
    // Configure to play even in silent mode if appropriate for your app
    // Adjust category/options based on desired behavior (mixWithOthers, duckOthers, etc.)
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      // If it fails, we still can speak; system may manage session.
      #if DEBUG
      print("SpeechService: Failed to set audio session: \(error)")
      #endif
    }
  }
}

extension SpeechService {
  static let shared = SpeechService(languageCode: "en-US")
}

//
//  AudioPlayerService.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 31.07.2025.
//

import Foundation
import AVFoundation

final class AudioPlayerService {
  var audioPlayer: AVAudioPlayer?
  private(set) var errorMessage: String?
  
  func playSound(named fileName: String) {
    guard let soundPath = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
      errorMessage = "Failed to find '\(fileName).mp3' file."
      print("Failed to find '\(fileName).mp3' file.")
      return
    }
    
    let soundURL = URL(fileURLWithPath: soundPath)
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
      audioPlayer?.play()
    } catch {
      print("Failed to play audio: \(error.localizedDescription)")
    }
  }
}

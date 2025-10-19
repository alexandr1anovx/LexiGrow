//
//  PreferencesView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 20.09.2025.
//

import SwiftUI

struct PreferencesView: View {
  @AppStorage("topic_sort_option") private var topicSortOption: TopicSortOption = .defaultOrder
  @AppStorage("automatic_sound_playback") private var isTurnedAudioPlayback = false
  
  var body: some View {
    Form {
      Section("Lessons") {
        Picker("Topic sorting", selection: $topicSortOption) {
          ForEach(TopicSortOption.allCases) {
            Text($0.rawValue).tag($0)
          }
        }.pickerStyle(.menu)
        
        Toggle("Automatic audio playback", isOn: $isTurnedAudioPlayback)
      }
    }
  }
}

//
//  SettingsScreen.swift
//  ReWord
//
//  Created by Alexander Andrianov on 10.08.2025.
//

import SwiftUI

struct SettingsScreen: View {
  
  @AppStorage(AppStorageKeys.appTheme) private var appTheme: AppTheme = .system
  @AppStorage(AppStorageKeys.topicSortOption) private var topicSortOption: TopicSortOption = .defaultOrder
  @AppStorage(AppStorageKeys.isAutomaticAudioPlaybackOn) private var isAutomaticAudioPlaybackOn = false
  
  
  @State private var triggerSelection = false
  
  var body: some View {
    Form {
      Section("Зовнішній вигляд") {
        Picker("Тема застосунку", selection: $appTheme) {
          ForEach(AppTheme.allCases) {
            Text($0.title)
          }
        }
      }
      
      Section("Аудіо") {
        Toggle("Озвучувати слова", isOn: $isAutomaticAudioPlaybackOn)
      }
      
      Section("Сортування") {
        Picker("Теми", selection: $topicSortOption) {
          ForEach(TopicSortOption.allCases) {
            Text($0.rawValue)
              .tag($0)
          }
        }
        
      }
    }
    .navigationTitle("Налаштування")
    .navigationBarTitleDisplayMode(.inline)
  }
}
#Preview {
  NavigationView {
    SettingsScreen()
  }
}

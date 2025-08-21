//
//  Bundle+Extension.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 14.07.2025.
//

import Foundation

/*
extension Bundle {
  func decode<T: Codable>(_ type: T.Type, from file: String) -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("⚠️ Failed to find \(file) in Bundle.")
    }
    guard let data = try? Data(contentsOf: url) else {
      fatalError("⚠️ Failed to get \(file) from Bundle.")
    }
    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(T.self, from: data) else {
      fatalError("⚠️ Failed to decode \(file) from Bundle.")
    }
    return decodedData
  }
}
*/

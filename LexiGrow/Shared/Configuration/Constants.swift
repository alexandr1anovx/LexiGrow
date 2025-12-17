//
//  Constants.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 06.07.2025.
//

import Foundation

enum Constants {
  static let supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as! String
  static let supabaseAPIKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_API_KEY") as! String
}

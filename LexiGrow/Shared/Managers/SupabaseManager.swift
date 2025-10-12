//
//  SupabaseManager.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 12.10.2025.
//

import Supabase
import Foundation

final class SupabaseManager {
  static let shared = SupabaseManager()
  
  let client: SupabaseClient
  
  private init() {
    let supabaseURL = URL(string: Constants.supabaseURL)!
    let supabaseKey = Constants.supabaseAPIKey
    self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
  }
}

//
//  SupabaseService.swift
//  ReWord
//
//  Created by Alexander Andrianov on 23.10.2025.
//

import Supabase
import Foundation

final class SupabaseService {
  static let shared = SupabaseService()
  
  let client: SupabaseClient
  
  private init() {
    let supabaseURL = URL(string: Constants.supabaseURL)!
    let supabaseKey = Constants.supabaseAPIKey
    self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
  }
}

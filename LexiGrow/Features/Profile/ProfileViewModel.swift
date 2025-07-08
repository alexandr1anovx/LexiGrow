//
//  ProfileViewModel.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 08.07.2025.
//

import Foundation

@Observable final class ProfileViewModel {
  var name: String = User.mockUser.name
  var surname: String = User.mockUser.surname
  var email: String = User.mockUser.email
  var username: String? = User.mockUser.username
  var joinDate: String = User.mockUser.formattedDate
  
  var isShownSignOutSheet: Bool = false
  var isShownDeleteAccountSheet: Bool = false
  var isShownLanguageAlert: Bool = false
}

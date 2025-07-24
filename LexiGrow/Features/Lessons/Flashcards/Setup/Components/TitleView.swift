//
//  TitleView.swift
//  LexiGrow
//
//  Created by Alexander Andrianov on 24.07.2025.
//

import SwiftUI

struct TitleView: View {
  var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text("Flash")
        Text("Cards")
          .foregroundStyle(.pink)
      }
      .font(.title2)
      .fontWeight(.bold)
      Text("Master Your Knowledge, One Card at a Time.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  TitleView()
}

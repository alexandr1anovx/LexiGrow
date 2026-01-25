//
//  DefaultProgressView.swift
//  ReWord
//
//  Created by Alexander Andrianov on 24.10.2025.
//

import SwiftUI

struct DefaultProgressView: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(.systemGray)
        .frame(width: 60, height: 60)
      ProgressView()
    }
  }
}

#Preview {
  DefaultProgressView()
}

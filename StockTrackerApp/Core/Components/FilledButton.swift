//
//  FilledButton.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import SwiftUI

struct FilledButton: ButtonStyle {
    var foregroundStyle: Color
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundStyle)
            .background(backgroundColor)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

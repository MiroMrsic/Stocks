//
//  BoldButtonWithAction.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import SwiftUI

struct BoldButtonWithAction: View {
    var buttonTitle: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(buttonTitle)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}

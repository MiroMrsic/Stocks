//
//  EmptyStateView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import SwiftUI

struct EmptyStateView: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.headline)
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            Spacer()
        }
        .padding(60)
        .lineLimit(3)
        .multilineTextAlignment(.center)
        
    }
}

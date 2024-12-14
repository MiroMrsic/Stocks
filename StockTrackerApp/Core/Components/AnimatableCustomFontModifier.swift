//
//  AnimatableCustomFontModifier.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import SwiftUI

struct AnimatableCustomFontModifier: AnimatableModifier {
    
    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

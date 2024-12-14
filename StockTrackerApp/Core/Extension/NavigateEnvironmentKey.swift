//
//  NavigateEnvironmentKey.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 02.12.2024..
//

import SwiftUI

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue: (AppState) -> Void = { _ in  }
}

extension EnvironmentValues {
    var appState: (AppState) -> Void {
        get { self[NavigateEnvironmentKey.self]}
        set { self[NavigateEnvironmentKey.self] = newValue }
    }
}



//
//  ContentViewModel.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 02.12.2024..
//

import Foundation
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var currentAppState: AppState = .home
    
    init() {}
    
    func handleUserSession() {
        FirebaseSession.shared.isUserLoggedIn() ?
        (currentAppState = .home) : (currentAppState = .onBoarding)
    }
}



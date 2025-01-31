//
//  ContentView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            switch viewModel.currentAppState {
            case .home:
                StockListView()
            case .onBoarding:
                OnboardingView()
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.appState) { currentAppState in
            DispatchQueue.main.async {
                viewModel.currentAppState = currentAppState
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.handleUserSession()
            }
        }
    }
}

#Preview {
    ContentView()
}

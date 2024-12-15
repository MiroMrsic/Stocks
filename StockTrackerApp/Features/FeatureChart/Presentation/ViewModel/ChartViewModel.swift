//
//  ChartViewModel.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import Foundation
import SwiftUI

@MainActor
class ChartViewModel: ObservableObject {
    @Published var selectedRange: ChartRange = .oneWeek {
        didSet {
            Task {
                await fetchHistoricalData()
            }
        }
    }
    
    @Published var historicalData: [OptionContract] = []
    @Published var color: Color = .blue
    @Published var responseMessage: String? = nil
    @Published var toastManager = ToastManager()
    
    private var stock: Stock
    private var repository: ChartProtocol
    private var cacheData: [ChartRange: [OptionContract]] = [:]
    
    init(
        stock: Stock,
        repository: ChartProtocol = ChartRepository()
    ) {
        self.stock = stock
        self.repository = repository
    }
    
    func fetchHistoricalData() async {
        if let historicalData = cacheData[selectedRange] {
            self.historicalData = historicalData
            return
        }
        
        do {
            let response = try await repository.getHistorical(symbol: stock.symbol, range: selectedRange)
            self.historicalData = response.data
            self.cacheData[selectedRange] = response.data
            self.responseMessage = response.data.isEmpty ? response.message : nil
        } catch {
            self.toastManager.showErrorToast(withMessage: error.localizedDescription)
        }
    }
}

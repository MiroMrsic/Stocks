//
//  StockDetailViewModel.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import Foundation

@MainActor
class StockDetailViewModel: ObservableObject {
    @Published var stock: Stock
    @Published var toastManager = ToastManager()
    @Published var historicalData = [OptionContract]()
    
    private let repository: StockDetailProtocol
    
    init(
        repository: StockDetailProtocol = StockDetailRepository(),
        stock: Stock
    ) {
        self.repository = repository
        self.stock = stock
    }
    
    func getPriceChange() async {
        guard shouldGetPriceChange() else { return }
        
        do {
            async let weeklyResponse: WeeklyResponse = try await repository.getTimeSeries(
                symbol: stock.symbol,
                type: .weekly
            )
            
            async let monthlyResponse: MonthlyResponse =  try await repository.getTimeSeries(
                symbol: stock.symbol,
                type: .monthly
            )
            
            let weekly = try await weeklyResponse
            let monthly = try await monthlyResponse
            
            stock.weeklyChange = await getPriceChangeDescription(for: weekly.timeSeries)
            stock.monthlyChange = await getPriceChangeDescription(for: monthly.timeSeries)
            stock.changeUpdateAt = .now
            
            try await saveStock(stock)
            
        } catch {
            self.toastManager.showErrorToast(withMessage: error.localizedDescription)
        }
    }
    
    private func getPriceChangeDescription(for timeSeries: [String: TimeSeriesEntry]) async -> String? {
        if let priceChange = TimeSeriesUtil.getPriceChange(for: timeSeries) {
            return priceChange.description + "%"
        }
        return nil
    }
    
    func saveStock(_ stock: Stock) async throws {
        try await repository.saveStock(stock: stock)
    }
    
    func shouldGetPriceChange() -> Bool {
        stock.weeklyChange == nil ||
        stock.monthlyChange == nil ||
        stock.changeUpdateAt?.isToday == false
    }
}

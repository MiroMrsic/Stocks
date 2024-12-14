//
//  ChartRepository.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

protocol ChartProtocol {
    func getHistorical(symbol: String, range: ChartRange) async throws -> HistoricalResponse
}

final class ChartRepository: ChartProtocol {
    func getHistorical(symbol: String, range: ChartRange) async throws -> HistoricalResponse {
        try await RestApiClient.shared.getHistorical(symbol: symbol, range: range)
    }
}

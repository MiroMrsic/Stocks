//
//  StockDetailRepository.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

protocol StockDetailProtocol {
    func getTimeSeries<T: Codable>(symbol: String, type: TimeSeriesType) async throws -> T
    func saveStock(stock: Stock) async throws
}

final class StockDetailRepository: StockDetailProtocol {
    private let firestoreManager: FirestoreManager
    
    init(firestoreManager: FirestoreManager = .shared) {
        self.firestoreManager = firestoreManager
    }
    
    func getTimeSeries<T: Codable>(symbol: String, type: TimeSeriesType) async throws -> T {
        try await RestApiClient.shared.getTimeSeries(symbol: symbol, type: type)
    }
    
    func saveStock(stock: Stock) async throws {
        try await firestoreManager.saveStock(stock: stock, userId: stock.userId)
    }
}

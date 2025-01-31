//
//  StockListRepostitory.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import Firebase
import FirebaseFirestore

protocol StockRepositoryProtocol {
    func fetchSavedStocks(for userId: String) async throws -> [Stock]
    func saveStock(stock: Stock, userId: String) async throws
    func deleteStock(_ stock: Stock) async throws
    func getGlobalQuote(symbol: String) async throws -> GlobalQuoteResponse
    func subscribeToStockUpdates() async throws -> [Stock]
}

class StockRepository: StockRepositoryProtocol {
    private let firestoreManager: MyFirestoreActor
    
    init(firestoreManager: MyFirestoreActor = FirestoreActor.shared) {
        self.firestoreManager = firestoreManager
    }
    
    func subscribeToStockUpdates() async throws -> [Stock] {
        return try await firestoreManager.subscribeToStockUpdates()
    }
    
    func fetchSavedStocks(for userId: String) async throws -> [Stock] {
        return try await firestoreManager.fetchSavedStocks(for: userId)
    }
    
    func saveStock(stock: Stock, userId: String) async throws {
        try await firestoreManager.saveStock(stock: stock, userId: userId)
    }
    
    func deleteStock(_ stock: Stock) async throws {
        try await firestoreManager.deleteStock(stock)
    }
    
    func getGlobalQuote(symbol: String) async throws -> GlobalQuoteResponse {
        return try await RestApiClient.shared.getGlobalQuote(symbol: symbol)
    }
}

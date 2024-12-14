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
    func subscribeToStockUpdates(_ completion: @escaping (Result<[Stock], NetworkError>) -> Void)
}

class StockRepository: StockRepositoryProtocol {
    private let firestoreManager: FirestoreManager
    
    init(firestoreManager: FirestoreManager = .shared) {
        self.firestoreManager = firestoreManager
    }
    
    func subscribeToStockUpdates(
        _ completion: @escaping (Result<[Stock], NetworkError>) -> Void
    ) {
        firestoreManager.db.collection("stocks").addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(.Response(response: "Error fetching documents: \(error.localizedDescription)")))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.Response(response: "No documents found")))
                return
            }
            
            let stocks: [Stock] = documents.compactMap { snapshot in
                do {
                    return try snapshot.data(as: Stock.self)
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                    return nil
                }
            }
            
            if stocks.isEmpty {
                return completion(.failure(.Response(response: "No valid stock data found")))
            }
            
            completion(.success(stocks))
        }
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

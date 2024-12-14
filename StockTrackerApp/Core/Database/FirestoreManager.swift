//
//  FirestoreManager.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 05.12.2024..
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager()
    
    let db: Firestore
    
    private init() {
        self.db = Firestore.firestore()
    }
    
    // MARK: - Fetch Saved Stocks
    
    func fetchSavedStocks(for userId: String) async throws -> [Stock] {
        let snapshot = try await db.collection("stocks").getDocuments()
        return try snapshot.documents.compactMap { document in
            let stock = try document.data(as: Stock.self)
            return stock.userId == userId ? stock : nil
        }
    }
    
    // MARK: - Save Stock
    
    func saveStock(stock: Stock, userId: String?) async throws {
        var stock = stock
        stock.userId = userId
        let documentRef = db.collection("stocks").document()
        try documentRef.setData(from: stock)
    }
    
    // MARK: - Delete Stock
    
    func deleteStock(_ stock: Stock) async throws {
        guard let id = stock.id else { return }
        try await db.collection("stocks").document(id).delete()
    }
}

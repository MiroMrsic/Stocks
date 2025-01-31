//
//  FirestoreManager.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 05.12.2024..
//

import FirebaseFirestore
import FirebaseAuth

@globalActor struct FirestoreActor {
    static let shared = MyFirestoreActor()
}

actor MyFirestoreActor {
    let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    // MARK: - Fetch Saved Stocks
    
    func fetchSavedStocks(for userId: String) async throws -> [Stock] {
        let query = db.collection("stocks").whereField("userId", isEqualTo: userId)
        let snapshot = try await query.getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: Stock.self)
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
    
    func subscribeToStockUpdates() async throws -> [Stock] {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("stocks").addSnapshotListener { querySnapshot, error in
                if let error = error {
                    continuation.resume(throwing: NetworkError.Response(response: "Error fetching documents: \(error.localizedDescription)"))
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    continuation.resume(throwing: NetworkError.Response(response: "No documents found"))
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
                    continuation.resume(throwing: NetworkError.Response(response: "No valid stock data found"))
                } else {
                    continuation.resume(returning: stocks)
                }
            }
        }
    }
}

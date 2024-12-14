//
//  SymbolSearchResponse.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 11.12.2024..
//

// MARK: - SymbolSearchResponse
struct SymbolSearchResponse: Codable {
    let bestMatches: [BestMatch]
}

// MARK: - BestMatch
struct BestMatch: Codable {
    let symbol: String
    let name: String
    let type: String
    let region: String
    let marketOpen: String
    let marketClose: String
    let timezone: String
    let currency: String
    let matchScore: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case region = "4. region"
        case marketOpen = "5. marketOpen"
        case marketClose = "6. marketClose"
        case timezone = "7. timezone"
        case currency = "8. currency"
        case matchScore = "9. matchScore"
    }
}

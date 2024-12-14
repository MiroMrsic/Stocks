//
//  StockFilterCriterion.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 14.12.2024..
//

enum StockFilterCriterion: String, CaseIterable {
    case all = "All"
    case priceIncrease = "Price Increase"
    case priceDecrease = "Price Decrease"
    case significantChange = "Significant Change"
    
    var description: String {
        switch self {
        case .all:
            return "All Stocks"
        case .priceIncrease:
            return "Price Increase"
        case .priceDecrease:
            return "Price Decrease"
        case .significantChange:
            return "Significant Change"
        }
    }
}

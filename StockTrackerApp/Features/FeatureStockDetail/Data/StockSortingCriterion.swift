//
//  StockSortingCriterion.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 14.12.2024..
//

enum StockSortingCriterion: String, CaseIterable {
    case reset = "Reset"
    case price = "Price"
    case dailyChange = "Daily Change"
    case weeklyChange = "Weekly Change"
    
    var description: String {
        switch self {
        case .price:
            return "By Price"
        case .dailyChange:
            return "By Daily Change"
        case .weeklyChange:
            return "By Weekly Change"
        case .reset:
            return "Reset Sorting"
        }
    }
}


//
//  ChartRange.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import Foundation

public enum ChartRange: String, CaseIterable, Identifiable, Sendable {
    public var id: Self { self }
    case oneDay = "1d"
    case oneWeek = "5d"
    case oneMonth = "1mo"
    case threeMonth = "3mo"
    case sixMonth = "6mo"
    case ytd
    case oneYear = "1y"
    case twoYear = "2y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case max
    
    public var interval: String {
        switch self {
        case .oneDay: return "1m"
        case .oneWeek: return "5m"
        case .oneMonth: return "90m"
        case .threeMonth, .sixMonth, .ytd, .oneYear, .twoYear: return "1d"
        case .fiveYear, .tenYear: return "1wk"
        case .max: return "3mo"
        }
    }

    var dateFormat: String {
        switch self {
        case .oneDay: return "yyyy-MM-dd" // Today
        case .oneWeek, .oneMonth: return "yyyy-MM-dd"
        case .threeMonth, .sixMonth, .ytd: return "yyyy-MM-dd"
        case .oneYear, .twoYear: return "yyyy-MM-dd"
        case .fiveYear, .tenYear, .max: return "yyyy-MM-dd"
        }
    }
    
    var title: String {
        switch self {
        case .oneDay: return "1D"
        case .oneWeek: return "1W"
        case .oneMonth: return "1M"
        case .threeMonth: return "3M"
        case .sixMonth: return "6M"
        case .oneYear: return "1Y"
        case .twoYear: return "2Y"
        case .fiveYear: return "5Y"
        case .tenYear: return "10Y"
        case .ytd: return "YTD"
        case .max: return "ALL"
        }
    }

    func getDateForRange() -> String {
        let calendar = Calendar.current
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var startDate: Date
        
        switch self {
        case .oneDay:
            startDate = today // Same day
        case .oneWeek:
            startDate = calendar.date(byAdding: .day, value: -7, to: today)!
        case .oneMonth:
            startDate = calendar.date(byAdding: .month, value: -1, to: today)!
        case .threeMonth:
            startDate = calendar.date(byAdding: .month, value: -3, to: today)!
        case .sixMonth:
            startDate = calendar.date(byAdding: .month, value: -6, to: today)!
        case .ytd:
            startDate = calendar.date(byAdding: .year, value: -1, to: today)!
        case .oneYear:
            startDate = calendar.date(byAdding: .year, value: -1, to: today)!
        case .twoYear:
            startDate = calendar.date(byAdding: .year, value: -2, to: today)!
        case .fiveYear:
            startDate = calendar.date(byAdding: .year, value: -5, to: today)!
        case .tenYear:
            startDate = calendar.date(byAdding: .year, value: -10, to: today)!
        case .max:
            startDate = calendar.date(byAdding: .year, value: -15, to: today)!
        }

        // Return the formatted date string
        return dateFormatter.string(from: startDate)
    }
}

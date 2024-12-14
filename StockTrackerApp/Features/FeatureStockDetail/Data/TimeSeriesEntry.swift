//
//  TimeSeriesEntry.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 11.12.2024..
//

struct TimeSeriesEntry: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
    }
}

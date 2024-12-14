//
//  WeeklyResponse.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

struct WeeklyResponse: Codable {
    let metaData: MetaData
    let timeSeries: [String: TimeSeriesEntry]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Weekly Time Series"
    }
}

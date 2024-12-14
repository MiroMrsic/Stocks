//
//  TimeSeriesUtil.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import Foundation

struct TimeSeriesUtil {
    static func getPriceChange(for timeSeries: [String: TimeSeriesEntry]) -> Double? {
        // Sort the timestamps to find the latest and the previous one
        let sortedTimestamps = timeSeries.keys.sorted(by: >)
        
        guard let latestTimestamp = sortedTimestamps.first,
              let previousTimestamp = sortedTimestamps.dropFirst().first,
              let latestEntry = timeSeries[latestTimestamp],
              let previousEntry = timeSeries[previousTimestamp],
              let latestPrice = Double(latestEntry.close),
              let previousPrice = Double(previousEntry.close) else {
            return nil
        }
        
        // Calculate the price change as a percentage
        let priceChange = ((latestPrice - previousPrice) / previousPrice) * 100
        
        // Round to 4 decimal places
        let roundedPriceChange = (priceChange * 10000).rounded() / 10000
        
        return roundedPriceChange
    }
}

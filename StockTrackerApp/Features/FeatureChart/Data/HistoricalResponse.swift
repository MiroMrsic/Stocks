//
//  HistoricalResponse.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import Foundation

struct HistoricalResponse: Codable {
    let endpoint: String
    let message: String
    let data: [OptionContract]
}

struct OptionContract: Codable, Identifiable {
    var id = UUID()
    let contractID: String
    let symbol: String
    let expiration: String
    let strike: String
    let type: String
    let last: String
    let mark: String
    let bid: String
    let bidSize: String
    let ask: String
    let askSize: String
    let volume: String
    let openInterest: String
    let date: String
    let impliedVolatility: String
    let delta: String
    let gamma: String
    let theta: String
    let vega: String
    let rho: String

    enum CodingKeys: String, CodingKey {
        case contractID = "contractID"
        case symbol = "symbol"
        case expiration = "expiration"
        case strike = "strike"
        case type = "type"
        case last = "last"
        case mark = "mark"
        case bid = "bid"
        case bidSize = "bid_size"
        case ask = "ask"
        case askSize = "ask_size"
        case volume = "volume"
        case openInterest = "open_interest"
        case date = "date"
        case impliedVolatility = "implied_volatility"
        case delta = "delta"
        case gamma = "gamma"
        case theta = "theta"
        case vega = "vega"
        case rho = "rho"
    }
}

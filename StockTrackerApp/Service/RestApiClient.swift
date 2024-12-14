//
//  RestApiClient.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import Foundation
import Alamofire

class RestApiClient {
    static let shared = RestApiClient()
    
    private init() {}
    
    func request<T: Decodable>(_ route: StockAPI, type: T.Type) async throws -> T {
        let urlRequest = try route.asURLRequest()
        let dataResponse = await AF.request(urlRequest).serializingDecodable(T.self).response
        
        if let error = dataResponse.error {
            throw error
        }
        
        guard let value = dataResponse.value else {
            throw NetworkError.NoData
        }
        
        return value
    }
    
    func getTimeSeries<T: Codable>(symbol: String, type: TimeSeriesType) async throws -> T {
        return try await request(
            .getTimeSeries(symbol: symbol, type: type),
            type: T.self
        )
    }
    
    func getHistorical(symbol: String, range: ChartRange) async throws -> HistoricalResponse {
        return try await request(
            .getHistorical(symbol: symbol, range: range),
            type: HistoricalResponse.self
        )
    }
    
    func searchSymbol(keywords: String) async throws -> SymbolSearchResponse {
        return try await request(
            .searchSymbol(keywords: keywords),
            type: SymbolSearchResponse.self
        )
    }
    
    func getGlobalQuote(symbol: String) async throws -> GlobalQuoteResponse {
        return try await request(
            .getGlobalQuote(symbol: symbol),
            type: GlobalQuoteResponse.self
        )
    }
}

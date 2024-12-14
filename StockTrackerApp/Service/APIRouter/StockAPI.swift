//
//  StockAPI.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import Foundation
import Alamofire

enum StockAPI: URLRequestConvertible {
    case getTimeSeries(symbol: String, type: TimeSeriesType)
    case getHistorical(symbol: String, range: ChartRange)
    case searchSymbol(keywords: String)
    case getGlobalQuote(symbol: String)

    var method: HTTPMethod {
        switch self {
        case .getTimeSeries, .searchSymbol, .getGlobalQuote, .getHistorical:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getTimeSeries, .searchSymbol, .getGlobalQuote, .getHistorical:
            return "/query"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .getTimeSeries(symbol, type):
            let parameters: Parameters = [
                "function": "TIME_SERIES_\(type.rawValue.uppercased())",
                "symbol": symbol,
                "apikey": Constants.apiKey
            ]
            
            return parameters
            
        case let .searchSymbol(keywords):
            return [
                "function": "SYMBOL_SEARCH",
                "keywords": keywords,
                "apikey": Constants.apiKey
            ]
            
        case let .getHistorical(symbol, range):
            let parameters: Parameters = [
                "function": "HISTORICAL_OPTIONS",
                "symbol": symbol,
                "apikey": Constants.apiKey,
                "date": range.getDateForRange()
            ]
            
            return parameters
            
        case let .getGlobalQuote(symbol):
            return [
                "function": "GLOBAL_QUOTE",
                "symbol": symbol,
                "apikey": Constants.apiKey
            ]
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getTimeSeries, .searchSymbol, .getGlobalQuote, .getHistorical:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try "https://www.alphavantage.co".asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method
        
        if let headers = headers {
            request.headers = headers
        }
        
        switch self {
        case .getTimeSeries, .searchSymbol, .getGlobalQuote, .getHistorical:
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        
        return request
    }
}

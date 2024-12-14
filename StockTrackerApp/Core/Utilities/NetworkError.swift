//
//  NetworkError.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

enum NetworkError: Error {
    case BadUrl
    case NoData
    case DecodingError
    case BadStatusCode
    case RealmError(response: String)
    case Response(response: String)
    
    var description: String? {
        switch self {
        case .BadUrl:
            return "Bad URL"
        case .NoData:
            return "No data"
        case .DecodingError:
            return "Decoding error"
        case .BadStatusCode:
            return "Bad status code"
        case .RealmError(let message):
            return "Database error: \(message)"
        case .Response(let response):
            return response
        }
    }
}

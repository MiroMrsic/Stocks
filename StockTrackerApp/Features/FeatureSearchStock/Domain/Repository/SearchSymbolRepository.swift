//
//  SearchSymbolRepository.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

protocol SearchSymbolProtocol {
    func searchSymbol(keywords: String) async throws -> SymbolSearchResponse
}

final class SearchSymbolRepository: SearchSymbolProtocol {
    
    func searchSymbol(keywords: String) async throws -> SymbolSearchResponse {
        return try await RestApiClient.shared.searchSymbol(keywords: keywords)
    }
}


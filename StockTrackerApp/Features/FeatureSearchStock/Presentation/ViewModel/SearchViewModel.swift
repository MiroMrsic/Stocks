//
//  SearchViewModel.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import Combine
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var stocks = [Stock]()
    @Published var query: String = ""
    @Published var toastManager: ToastManager = .init()
    
    var isSearching: Bool { !trimmedQuery.isEmpty }
    
    private var trimmedQuery: String { query.trimmed() }
    private var cancellables = Set<AnyCancellable>()
    private let repository: SearchSymbolProtocol
    private var cache = [String: [Stock]]()
    private let cacheSize = 100
    
    init(
        query: String = "",
        repository: SearchSymbolProtocol = SearchSymbolRepository()
    ) {
        self.query = query
        self.repository = repository
        self.startObserving()
    }
    
    private func startObserving() {
        $query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.onQueryChanged()
            }
            .store(in: &cancellables)
    }
    
    func onQueryChanged() {
        Task {
            await searchTickers()
        }
    }
    
    private func searchTickers() async {
        let searchQuery = trimmedQuery
        guard !searchQuery.isEmpty else { return }
        
        if let cachedStocks = cache[searchQuery] {
            self.stocks = cachedStocks
            return
        }
        
        do {
            let response = try await repository.searchSymbol(keywords: searchQuery).bestMatches
            let stocks = response.map { self.toStock($0)}
            
            self.stocks = stocks
            self.updateCache(with: stocks, for: searchQuery)
        } catch {
            self.toastManager.showErrorToast(withMessage: error.localizedDescription)
        }
    }
    
    private func toStock(_ bestMatch: BestMatch) -> Stock {
        .init(
            id: UUID().uuidString.lowercased(),
            name: bestMatch.name,
            symbol: bestMatch.symbol
        )
    }
    
    private func updateCache(with stocks: [Stock], for query: String) {
        if cache.count >= cacheSize, let firstKey = cache.keys.first {
            cache.removeValue(forKey: firstKey)
        }
        
        cache[query] = stocks
    }
}

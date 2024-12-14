//
//  StockListViewModel.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

@MainActor
final class StockListViewModel: ObservableObject {
    @Published var savedStocks = [Stock]()
    @Published var toastManager = ToastManager()
    @Published var selectedStock: Stock? = nil
    @Published var subtitleText: String? = nil
    @Published private var user: User?
    
    private var repository: StockRepositoryProtocol
    private var allStocks = [Stock]()
    private var cancellables = Set<AnyCancellable>()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var listenerRegistration: ListenerRegistration?
    private var priceUpdateTimer: Timer?
    private let priceUpdateInterval: TimeInterval = 30 * 60 // update every 30 mins
    private let priceChangeThreshold: Double = 5.0
    
    private let subtitleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter
    }()
    
    init(
        repository: StockRepositoryProtocol = StockRepository()
    ) {
        self.repository = repository
        self.subtitleText = subtitleDateFormatter.string(from: Date())
        self.registerAuthStateHandler()
        self.subscribeToStockUpdates()
        self.startPeriodicPriceUpdates()
    }
    
    deinit {
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
        
        priceUpdateTimer?.invalidate()
    }
}

extension StockListViewModel {
    func startPeriodicPriceUpdates() {
        priceUpdateTimer = Timer.scheduledTimer(
            withTimeInterval: priceUpdateInterval,
            repeats: true
        ) { _ in
            DispatchQueue.main.async { [weak self] in
                self?.updateAllStockPrices()
            }
        }
    }
    
    func stopPeriodicPriceUpdates() {
        priceUpdateTimer?.invalidate()
        priceUpdateTimer = nil
    }
    
    
    func checkForSignificantPriceChange(for stock: Stock) {
        guard let previousPrice = stock.previousPrice,
              let currentPrice = stock.currentPrice,
              let previusPriceDouble = Double(previousPrice),
              let currentPriceDouble = Double(currentPrice)
        else { return }
        
        let change = ((currentPriceDouble - previusPriceDouble) / previusPriceDouble) * 100
        
        if abs(change) >= priceChangeThreshold {
            sendPriceChangeNotification(for: stock, change: change)
        }
    }
    
    func sendPriceChangeNotification(for stock: Stock, change: Double) {
        let content = UNMutableNotificationContent()
        content.title = "\(stock.name) Price Change"
        content.body = "The price of \(stock.symbol) has changed by \(String(format: "%.2f", change))%."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: stock.id ?? UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
    
    func unsubscribe() {
        guard listenerRegistration != nil else { return }
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
}

extension StockListViewModel {
    func sortStocks(by criterion: StockSortingCriterion) {
        switch criterion {
        case .price:
            savedStocks.sort { ($0.currentPrice ?? "") < ($1.currentPrice ?? "") }
        case .dailyChange:
            savedStocks.sort { ($0.dailyChange ?? "") < ($1.dailyChange ?? "") }
        case .weeklyChange:
            savedStocks.sort { ($0.weeklyChange ?? "") < ($1.weeklyChange ?? "") }
        case .reset:
            savedStocks = allStocks.sorted(by: {$0.name < $1.name })
        }
    }

    func filterStocks(by filter: StockFilterCriterion) {
        savedStocks = allStocks
        savedStocks = savedStocks.filter { stock in
            var matches = true
            
            switch filter {
            case .all:
                break
            case .priceIncrease:
                if let dailyChange = stock.dailyChange,
                   let change = Double(dailyChange.dropLast()) {
                    matches = matches && change > 0
                }
            case .priceDecrease:
                if let dailyChange = stock.dailyChange,
                   let change = Double(dailyChange.dropLast()) {
                    matches = matches && change < 0
                }
            case .significantChange:
                if let dailyChange = stock.dailyChange,
                   let change = Double(dailyChange.dropLast()) {
                    matches = matches && abs(change) >= priceChangeThreshold
                }
            }
            
            return matches
        }
        .sorted(by: {$0.name < $1.name })
    }
}

extension StockListViewModel {
    func onButtonPressed(_ stock: Stock) {
        guard let userId = user?.uid else { return }
        isSaved(stock) ? removeStock(stock) : saveStock(stock: stock, userId: userId)
    }
    
    func removeStock(_ stock: Stock) {
        savedStocks.removeAll { $0.id == stock.id }
        deleteStock(stock)
    }
    
    func isSaved(_ stock: Stock) -> Bool {
        savedStocks.contains { $0.id == stock.id }
    }
    
    func removeStock(at indexSet: IndexSet) {
        for index in indexSet {
            let stock = savedStocks.remove(at: index)
            deleteStock(stock)
        }
    }
    
    func getPriceChange(for stock: Stock) -> (String, String)? {
        guard let currentPrice = stock.currentPrice,
              let dailyChange = stock.dailyChange else {
            return nil
        }
        return (currentPrice, dailyChange)
    }
}

extension StockListViewModel {
    func registerAuthStateHandler() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
            self?.fetchSavedStocks()
        }
    }
    
    func updateAllStockPrices() {
        for stock in savedStocks {
            Task { [weak self] in
                await self?.updateStockPrice(stock)
            }
        }
    }
    
    func updateStockPrice(_ stock: Stock) async {
        guard let userId = user?.uid else { return }
        do {
            let results = try await repository.getGlobalQuote(symbol: stock.symbol)
            var updatedStock = stock
            updatedStock.currentPrice = results.globalQuote.price
            updatedStock.dailyChange = results.globalQuote.changePercent
            
            checkForSignificantPriceChange(for: updatedStock)
            
            if let index = savedStocks.firstIndex(where: { $0.id == stock.id }) {
                savedStocks[index] = updatedStock
            }
            
            try await repository.saveStock(stock: updatedStock, userId: userId)
            
        } catch {
            toastManager.showErrorToast(withMessage: error.localizedDescription)
        }
    }
    
    func fetchSavedStocks() {
        guard let userId = self.user?.uid else { return }
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let stocks = try await repository.fetchSavedStocks(for: userId)
                let filteredStocks = stocks.sorted(by: {$0.name < $1.name})
                
                self.savedStocks = filteredStocks
                self.allStocks = filteredStocks
            } catch {
                self.toastManager.showErrorToast(withMessage: error.localizedDescription)
            }
        }
    }
    
    func saveStock(stock: Stock, userId: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let results = try await repository.getGlobalQuote(symbol: stock.symbol)
                
                var stock = stock
                let previousPrice = stock.currentPrice
                
                stock.currentPrice = results.globalQuote.price
                stock.dailyChange = results.globalQuote.changePercent
                stock.previousPrice = previousPrice
                
                self.checkForSignificantPriceChange(for: stock)
                self.savedStocks.append(stock)
                self.allStocks.append(stock)
                
                try await repository.saveStock(stock: stock, userId: userId)
            } catch {
                self.toastManager.showErrorToast(withMessage: error.localizedDescription)
            }
        }
    }
    
    func deleteStock(_ stock: Stock) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await repository.deleteStock(stock)
            } catch {
                self.toastManager.showErrorToast(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func subscribeToStockUpdates() {
        guard let userId = self.user?.uid else { return }
        repository.subscribeToStockUpdates { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stocks):
                let filteredStocks = stocks
                    .filter {$0.userId == userId }
                    .sorted(by: {$0.name < $1.name})
                
                self.savedStocks = filteredStocks
                self.allStocks = filteredStocks
            case .failure(let error):
                self.toastManager.showErrorToast(withMessage: error.localizedDescription)
            }
        }
    }
}

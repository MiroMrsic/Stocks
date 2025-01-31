//
//  StockListView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import SwiftUI

struct StockListView: View {
    @StateObject private var viewModel = StockListViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @Environment(\.appState) private var appState
    
    var body: some View {
        VStack {
            stockListView
                .listStyle(.plain)
                .overlay { overlayView }
                .toolbar {
                    titleToolbar
                    bottomToolbar
                }
                .searchable(text: $searchViewModel.query)
                .onDisappear(perform: viewModel.unsubscribe)
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(), value: viewModel.savedStocks)
        .sheet(item: $viewModel.selectedStock) {
            StockDetailView(stock: $0)
                .presentationDetents([.height(560)])
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout")
                { FirebaseSession.shared.signOut { appState(.onBoarding) } }
                    .font(.title3.weight(.semibold))
            }
        }
        .toast(
            isPresenting: $viewModel.toastManager.isShowingErrorToast,
            duration: 6
        ) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .error(.red),
                title: searchViewModel.toastManager.errorToastMessage,
                style: .style(titleColor: .red,titleFont: .body, subTitleFont: .body)
            )
        }
    }
}

extension StockListView {
    private var stockListView: some View {
        List {
            ForEach(viewModel.savedStocks) { stock in
                StockCellView(
                    data: .init(
                        symbol: stock.symbol,
                        name: stock.name,
                        price: viewModel.getPriceChange(for: stock),
                        type: .main
                    )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedStock = stock
                }
            }
            .onDelete { viewModel.removeStock(at: $0) }
        }
        .opacity(searchViewModel.isSearching ? 0 : 1)
    }
    
    @ViewBuilder private var overlayView: some View {
        if viewModel.savedStocks.isEmpty {
            EmptyStateView(text: "Search & add symbol to see stock quotes")
        }
        
        if searchViewModel.isSearching {
            StockSearchView(searchViewModel: searchViewModel)
                .environmentObject(viewModel)
        }
    }
    
    private var titleToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            VStack(alignment: .leading, spacing: -4) {
                Text(Constants.appName).font(.title2.weight(.heavy))
                
                if let subtitleText = viewModel.subtitleText {
                    Text(subtitleText)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var bottomToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Menu {
                Section {
                    Menu {
                        ForEach(StockSortingCriterion.allCases, id: \.self) { criterion in
                            Button(action: {
                                viewModel.sortStocks(by: criterion)
                            }) {
                                Text(criterion.description)
                            }
                        }
                    } label: {
                        Text("Sort Stocks")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                }
                
                Section {
                    Menu {
                        ForEach(StockFilterCriterion.allCases, id: \.self) { filter in
                            Button(action: {
                                viewModel.filterStocks(by: filter)
                            }) {
                                Text(filter.description)
                            }
                        }
                    } label: {
                        Text("Filter Stocks")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                }
            } label: {
                Label("", systemImage: "ellipsis.circle.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
            }
            .disabled(viewModel.stockAreEmpty())
        }
    }
}

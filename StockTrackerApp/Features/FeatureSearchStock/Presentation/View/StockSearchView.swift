//
//  StockSearchView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import SwiftUI

struct StockSearchView: View {
    @EnvironmentObject var viewModel: StockListViewModel
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        List {
            ForEach(searchViewModel.stocks) { stock in
                StockCellView(
                    data: .init(
                        symbol: stock.symbol,
                        name: stock.name,
                        price: viewModel.getPriceChange(for: stock),
                        type: .search(
                            isSaved: viewModel.isSaved(stock),
                            onButtonTapped: { viewModel.onButtonPressed(stock) }
                        )
                    )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedStock = stock
                }
            }
        }
        .toast(
            isPresenting: $searchViewModel.toastManager.isShowingErrorToast,
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

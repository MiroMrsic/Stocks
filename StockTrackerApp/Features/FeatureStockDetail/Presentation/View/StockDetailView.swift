//
//  StockDetailView.swift
//  StocksApp
//
//  Created by Alfian Losari on 16/10/22.
//

import SwiftUI

struct StockDetailView: View {
    @StateObject private var viewModel: StockDetailViewModel
    @StateObject private var chartViewModel: ChartViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(stock: Stock) {
        _viewModel = .init(wrappedValue: .init(stock: stock))
        _chartViewModel = .init(wrappedValue: .init(stock: stock))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView.padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
            
            scrollView
        }
        .padding(.top)
        .background(Color(uiColor: .systemBackground))
        .task { await viewModel.getPriceChange() }
        .toast(
            isPresenting: $viewModel.toastManager.isShowingErrorToast,
            duration: 6
        ) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .error(.red),
                title: viewModel.toastManager.errorToastMessage,
                style: .style(titleColor: .red,titleFont: .body, subTitleFont: .body)
            )
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            exchangeCurrencyView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.horizontal)
            
            Divider()
            
            DateRangePickerView(selectedRange: $chartViewModel.selectedRange)
            
            Divider()
            
            ChartView(vm: chartViewModel)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 220)
            
            Divider().padding([.horizontal, .top])
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.spring(), value: viewModel.stock.dailyChange)
    }
    
    private var exchangeCurrencyView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let currentPrice = viewModel.stock.currentPrice {
                getStockInfoRow(
                    name: "Current price: ",
                    value: currentPrice
                )
            }
            
            if let dailyChange = viewModel.stock.dailyChange {
                getStockInfoRow(
                    name: "Daily change: ",
                    value: dailyChange
                )
            }
            
            if let weeklyChange = viewModel.stock.weeklyChange {
                getStockInfoRow(
                    name: "Weekly change: ",
                    value: weeklyChange
                )
            }
            
            if let monthlyChange = viewModel.stock.monthlyChange {
                getStockInfoRow(
                    name: "Monthly change: ",
                    value: monthlyChange
                )
            }
        }
    }
    
    private func getStockInfoRow(name: String, value: String) -> some View {
        HStack(alignment: .lastTextBaseline) {
            Text(name)
                .font(.subheadline.weight(.semibold))
            
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(uiColor: .secondaryLabel))
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(viewModel.stock.symbol)
                .font(.title.bold())
            
            Text(viewModel.stock.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            
            Spacer()
            
            closeButton
        }
    }
    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Circle()
                .frame(width: 36, height: 36)
                .foregroundStyle(.gray.opacity(0.1))
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 18).bold())
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
        }
        .buttonStyle(.plain)
    }
}

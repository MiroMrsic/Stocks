//
//  ChartView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 12.12.2024..
//

import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var vm: ChartViewModel
    
    var body: some View {
        VStack {
            if let responseMessage = vm.responseMessage {
                Text(responseMessage)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                    .padding(.top, 10)
            }
            
            chart
        }
        .padding(5)
        .task { await vm.fetchHistoricalData() }
        .animation(.spring(), value: vm.historicalData.isEmpty)
    }
    
    private var chart: some View {
        Chart {
            ForEach(Array(zip(vm.historicalData.indices, vm.historicalData)), id: \.0) { index, item in
                LineMark(
                    x: .value("Strike Price", Double(item.strike) ?? 0),
                    y: .value("Implied Volatility", Double(item.impliedVolatility) ?? 0)
                )
                .foregroundStyle(vm.foregroundMarkColor)
                
                AreaMark(
                    x: .value("Strike Price", Double(item.strike) ?? 0),
                    yStart: .value("Min", 0.0),
                    yEnd: .value("Max", Double(item.impliedVolatility) ?? 0)
                )
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [
                        vm.foregroundMarkColor,
                        .clear
                    ]), startPoint: .top, endPoint: .bottom)
                ).opacity(0.3)
            }
        }
        .frame(height: 300)
    }
}

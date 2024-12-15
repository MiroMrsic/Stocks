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
            } else {
                chart
            }
        }
        .padding(5)
        .task { await vm.fetchHistoricalData() }
        .animation(.spring(), value: vm.historicalData.isEmpty)
    }
    
    private var chart: some View {
        let data = vm.historicalData // date is always the same?
        return Chart {
            
            //            ForEach(data) { item in
            //                BarMark(
            //                    x: .value("Date", item.date),
            //                    y: .value("Price", item.strike)
            //                )
            //                .foregroundStyle(vm.foregroundMarkColor)
            //                .opacity(0.3)
            //            }
            //            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            ForEach(data) { item in
                LineMark(
                    x: .value("Strike Price", Double(item.strike) ?? 0),
                    y: .value("Implied Volatility", Double(item.impliedVolatility) ?? 0)
                )
                .foregroundStyle(vm.color)
                
                AreaMark(
                    x: .value("Strike Price", Double(item.strike) ?? 0),
                    yStart: .value("Min", 0.0),
                    yEnd: .value("Max", Double(item.impliedVolatility) ?? 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [vm.color,.clear]),
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .opacity(0.3)
            }
        }
        .frame(height: 300)
    }
}

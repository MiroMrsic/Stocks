//
//  StockListCellData.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

typealias PriceChange = (price: String, change: String)

struct StockListCellData {
    
    enum RowType {
        case main
        case search(isSaved: Bool, onButtonTapped: () -> ())
    }
    
    let symbol: String
    let name: String?
    let price: PriceChange?
    let type: RowType
}

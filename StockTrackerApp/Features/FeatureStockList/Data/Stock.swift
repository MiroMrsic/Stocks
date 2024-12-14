//
//  Stock.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import Foundation
import FirebaseFirestore

struct Stock: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var name: String
    var symbol: String
    var currentPrice: String?
    var previousPrice: String?
    var dailyChange: String?
    var weeklyChange: String?
    var monthlyChange: String?
    var userId: String?
    var changeUpdateAt: Date?
}

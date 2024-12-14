//
//  Ext+Date.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 14.12.2024..
//

import Foundation

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
}

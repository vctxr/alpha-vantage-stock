//
//  IntradayViewModel.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

struct IntradayViewModel {
    let symbol: String
    let open: String
    let high: String
    let low: String
    let dateTime: String
    let rawDate: String
    
    static var dateFormatter = DateFormatter()
    
    init(stockData: StockData, symbol: String) {
        self.symbol = symbol.uppercased()
        open = stockData.the1Open
        high = stockData.the2High
        low = stockData.the3Low
        dateTime = IntradayViewModel.formatDateString(dateString: stockData.dateTime)
        rawDate = stockData.dateTime
    }
    
    static func formatDateString(dateString: String) -> String {
        IntradayViewModel.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        IntradayViewModel.dateFormatter.locale = Locale(identifier: "en_US")
        let formattedDate = IntradayViewModel.dateFormatter.date(from: dateString)
        IntradayViewModel.dateFormatter.dateFormat = "dd MMM, YYYY HH:mm:ss"
        return (formattedDate != nil) ? IntradayViewModel.dateFormatter.string(from: formattedDate!) : "--"
    }
}

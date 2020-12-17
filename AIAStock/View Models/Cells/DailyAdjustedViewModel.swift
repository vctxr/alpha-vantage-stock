//
//  DailyAdjustedViewModel.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

struct DailyAdjustedViewModel {
    
    let symbol: [String]
    let open: [String]
    let low: [String]
    let dateTime: String
    
    static let dateFormatter = DateFormatter()
    
    init(stockData: [StockDataDailyAdjusted], symbols: [String]) {
        var symbolTemp: [String] = []
        var openTemp: [String] = []
        var lowTemp: [String] = []
        var dateTimeTemp = ""
        
        stockData.forEach { data in
            openTemp.append(data.the1Open)
            lowTemp.append(data.the3Low)
            dateTimeTemp = DailyAdjustedViewModel.formatDateString(dateString: data.dateTime)
        }
        
        symbols.forEach { symbolTemp.append($0) }
        
        symbol = symbolTemp
        open = openTemp
        low = lowTemp
        dateTime = dateTimeTemp
    }
    
    static func formatDateString(dateString: String) -> String {
        DailyAdjustedViewModel.dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = DailyAdjustedViewModel.dateFormatter.date(from: dateString)
        DailyAdjustedViewModel.dateFormatter.dateFormat = "dd MMM, YYYY"
        return (formattedDate != nil) ? DailyAdjustedViewModel.dateFormatter.string(from: formattedDate!) : "--"
    }
}

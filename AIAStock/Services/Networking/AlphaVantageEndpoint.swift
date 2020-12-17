//
//  AlphaVantageEndpoint.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

enum DataPointInterval: String, CaseIterable {
    case oneMin = "1min"
    case fiveMin = "5min"
    case fifteenMin = "15min"
    case thirtyMin = "30min"
    case sixtyMin = "60min"
}

enum OutputSize: String {
    case compact
    case full
}

enum AlphaVantageEndpoint: Endpoint {
    case intraday(symbol: String, interval: DataPointInterval, outputSize: OutputSize = .compact)
    case dailyAdjusted(symbol: String, outputSize: OutputSize = .compact)
}

extension AlphaVantageEndpoint {
    
    var baseUrl: String {
        "https://www.alphavantage.co"
    }
    
    var path: String {
        switch self {
        case .intraday:
            return "/query"
        case .dailyAdjusted:
            return "/query"
        }
    }
    
    var urlParameters: [URLQueryItem]? {
        var apiKey = ""
        if let data = KeyChain.load(key: "API_KEY") {
            apiKey = String(decoding: data, as: UTF8.self)
        }
        var urlQueryItems = [URLQueryItem(name: "apikey", value: apiKey)]

        switch self {
        case .intraday(symbol: let symbol, interval: let interval, outputSize: let outputSize):
            urlQueryItems.append(URLQueryItem(name: "function", value: "TIME_SERIES_INTRADAY"))
            urlQueryItems.append(URLQueryItem(name: "symbol", value: symbol))
            urlQueryItems.append(URLQueryItem(name: "interval", value: interval.rawValue))
            urlQueryItems.append(URLQueryItem(name: "outputsize", value: outputSize.rawValue))
            return urlQueryItems
        case .dailyAdjusted(symbol: let symbol, outputSize: let outputSize):
            urlQueryItems.append(URLQueryItem(name: "function", value: "TIME_SERIES_DAILY_ADJUSTED"))
            urlQueryItems.append(URLQueryItem(name: "symbol", value: symbol))
            urlQueryItems.append(URLQueryItem(name: "outputsize", value: outputSize.rawValue))
            return urlQueryItems
        }
    }
}

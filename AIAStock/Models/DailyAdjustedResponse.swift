//
//  DailyAdjustedResponse.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

struct DailyAdjustedResponse: Decodable {
    var metaData: MetaDataDailyAdjusted!
    var timeSeriesDaily: TimeSeriesDaily!

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in container.allKeys {
            if key.stringValue == "Meta Data" {
                let decodedMetaData = try container.decode(MetaDataDailyAdjusted.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                metaData = decodedMetaData
            } else {
                let decodedObject = try container.decode(TimeSeriesDaily.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                timeSeriesDaily = decodedObject
            }
        }
    }
}


// MARK: - MetaData

struct MetaDataDailyAdjusted: Decodable {
    let the1Information, the2Symbol, the3LastRefreshed, the4OutputSize: String
    let the5TimeZone: String

    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4OutputSize = "4. Output Size"
        case the5TimeZone = "5. Time Zone"
    }
}


// MARK: - Time Series Daily

struct TimeSeriesDaily: Decodable {
    var stockData: [StockDataDailyAdjusted]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray: [StockDataDailyAdjusted] = []
        for key in container.allKeys {
            let decodedObject = try container.decode(StockDataDailyAdjusted.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        stockData = tempArray
    }
}


// MARK: - Stock Data
struct StockDataDailyAdjusted: Decodable {
    let the1Open, the2High, the3Low, the4Close: String
    let the5AdjustedClose, the6Volume, the7DividendAmount, the8SplitCoefficient: String
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
        case the2High = "2. high"
        case the3Low = "3. low"
        case the4Close = "4. close"
        case the5AdjustedClose = "5. adjusted close"
        case the6Volume = "6. volume"
        case the7DividendAmount = "7. dividend amount"
        case the8SplitCoefficient = "8. split coefficient"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        the1Open = try container.decode(String.self, forKey: CodingKeys.the1Open)
        the2High = try container.decode(String.self, forKey: CodingKeys.the2High)
        the3Low = try container.decode(String.self, forKey: CodingKeys.the3Low)
        the4Close = try container.decode(String.self, forKey: CodingKeys.the4Close)
        the5AdjustedClose = try container.decode(String.self, forKey: CodingKeys.the5AdjustedClose)
        the6Volume = try container.decode(String.self, forKey: CodingKeys.the6Volume)
        the7DividendAmount = try container.decode(String.self, forKey: CodingKeys.the7DividendAmount)
        the8SplitCoefficient = try container.decode(String.self, forKey: CodingKeys.the8SplitCoefficient)

        dateTime = container.codingPath[1].stringValue
    }
}

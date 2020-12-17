//
//  IntradayResponse.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

struct IntradayResponse: Decodable {
    var metaData: MetaDataIntraday!
    var timeSeries: TimeSeries!
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in container.allKeys {
            if key.stringValue == "Meta Data" {
                let decodedMetaData = try container.decode(MetaDataIntraday.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                metaData = decodedMetaData
            } else {
                let decodedObject = try container.decode(TimeSeries.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                timeSeries = decodedObject
            }
        }
    }
}


// MARK: - Meta Data

struct MetaDataIntraday: Decodable {
    let the1Information, the2Symbol, the3LastRefreshed, the4Interval: String
    let the5OutputSize, the6TimeZone: String

    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4Interval = "4. Interval"
        case the5OutputSize = "5. Output Size"
        case the6TimeZone = "6. Time Zone"
    }
}


// MARK: - Time Series

struct TimeSeries: Decodable {
    var stockData: [StockData]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray: [StockData] = []
        for key in container.allKeys {
            let decodedObject = try container.decode(StockData.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        stockData = tempArray
    }
}


// MARK: - Stock Data

struct StockData: Decodable {
    let the1Open, the2High, the3Low, the4Close, the5Volume: String
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
        case the2High = "2. high"
        case the3Low = "3. low"
        case the4Close = "4. close"
        case the5Volume = "5. volume"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        the1Open = try container.decode(String.self, forKey: CodingKeys.the1Open)
        the2High = try container.decode(String.self, forKey: CodingKeys.the2High)
        the3Low = try container.decode(String.self, forKey: CodingKeys.the3Low)
        the4Close = try container.decode(String.self, forKey: CodingKeys.the4Close)
        the5Volume = try container.decode(String.self, forKey: CodingKeys.the5Volume)

        dateTime = container.codingPath[1].stringValue
    }
}


// MARK: - Dynamic Coding Keys

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}

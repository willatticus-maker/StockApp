//
//  DataModels.swift
//  StockApp
//
//  Created by Will Fk on 4/27/26.
//

import Foundation
struct MetaData: Codable {
    let information: String
    let symbol: String  
    let lastRefreshed: String
    let outputSize: String
    let timeZone: String

    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case outputSize = "4. Output Size"
        case timeZone = "5. Time Zone"
    }
}
struct DailyStockData: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

struct AlphaVantageResponse : Codable {
    let metaData: MetaData
    let timeSeries: [String: DailyStockData]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (Daily)"
        
        
    }
    var sortedTimeSeries: [(date: String, data: DailyStockData)] {
        timeSeries.map { (date: $0.key, data: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    
    
}

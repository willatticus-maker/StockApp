import Foundation
import SwiftUI
import UIKit
import Combine

@Observable
class NetworkClient: ObservableObject {
    
    
    private(set) var stockResponse: AlphaVantageResponse?
    var stockMatrix : [[AlphaVantageResponse?]] = []
    var testMatrix : [[AlphaVantageResponse?]] = [
        [AlphaVantageResponse(metaData: MetaData(information: "abc", symbol: "123", lastRefreshed: "2026-10-10", outputSize: "34", timeZone: "est"), timeSeries: ["TEST": DailyStockData(open: "1", high: "3", low: "2", close: "3", volume: "789")])],
        [AlphaVantageResponse(metaData: MetaData(information: "fit", symbol: "rev", lastRefreshed: "2026-10-10", outputSize: "34", timeZone: "est"), timeSeries: ["TEST": DailyStockData(open: "1", high: "3", low: "2", close: "3", volume: "789")])],
        [AlphaVantageResponse(metaData: MetaData(information: "hij", symbol: "evi", lastRefreshed: "2026-10-10", outputSize: "34", timeZone: "est"), timeSeries: ["TEST": DailyStockData(open: "1", high: "3", low: "2", close: "3", volume: "789")])],
        [AlphaVantageResponse(metaData: MetaData(information: "xyz", symbol: "hig", lastRefreshed: "2026-10-10", outputSize: "34", timeZone: "est"), timeSeries: ["TEST": DailyStockData(open: "1", high: "3", low: "2", close: "3", volume: "789")])]
    ]
    
    
    
    
    func getStockDetail(symbol:String) async {
print("started")
     let result = testMatrix.lazy
            .flatMap { $0 }
            .compactMap { $0 }
            .first { $0.metaData.symbol == symbol }

        if let foundObject = result {
            print("Found: \(foundObject.metaData.information)")
            for item in foundObject.sortedTimeSeries{
                print("date :\(item.date) Close: \(item.data.close)")
            }
        }
            
        

            else {
                print("Symbol not found.")
                        print("networking...")
                            let urlStr = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&outputsize=compact&apikey=26YEL3PQC5ZHFB1P"
                            
                            guard let url = URL(string: urlStr) else { return }
                            
                            do {
                                let decoder = JSONDecoder()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                decoder.dateDecodingStrategy = .formatted(formatter)
                                
                                let (data, response) = try await URLSession.shared.data(from: url)
                                
                                if let responseConverted = response as? HTTPURLResponse {
                                    self.stockResponse = try decoder.decode(AlphaVantageResponse.self, from: data)
                                    
                                    print ("status code :\(responseConverted.statusCode )")
                                    if let response = stockResponse {
                                        for item in response.sortedTimeSeries {
                                            print("date :\(item.date) Close: \(item.data.close)")
                                        }
                                        
                                    }
                                    
                                    
                                }
                            } catch let error {
                                print(error)
                            }
                            
                        }
                    }
                }



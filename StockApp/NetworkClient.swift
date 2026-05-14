import Foundation
import SwiftUI
import UIKit
import Combine

@Observable
class NetworkClient {
    private(set) var stockResponse: AlphaVantageResponse?
    

    var stockMatrix: [[AlphaVantageResponse]] = [[]]
    var myPortfolio: [String: Int] = [:]


    func findInMatrix(symbol: String) -> AlphaVantageResponse? {
        return stockMatrix.flatMap { $0 }.first { $0.metaData.symbol == symbol }
    }

    func getBatchStocks(symbols: [String]) async {
        for symbol in symbols {
            if findInMatrix(symbol: symbol) == nil {
                await getStockDetail(symbol: symbol)
            }
        }
    }

    func getStockDetail(symbol: String) async {
        let urlStr = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&outputsize=compact&apikey=26YEL3PQC5ZHFB1P"
        guard let url = URL(string: urlStr) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(AlphaVantageResponse.self, from: data)
            
            await MainActor.run {

                if self.stockMatrix.isEmpty { self.stockMatrix.append([]) }
                self.stockMatrix[0].append(response)
                self.stockResponse = response
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func getPriceData(for symbol: String, timeframe: String) -> [Double] {
        guard let response = findInMatrix(symbol: symbol) else { return [] }
        let allPrices = response.sortedTimeSeries.compactMap { Double($0.data.close) }.reversed()
        let priceArray = Array(allPrices)
        
        switch timeframe {
            case "1W": return Array(priceArray.suffix(7))
            case "1M": return Array(priceArray.suffix(30))
            case "YTD": return Array(priceArray.suffix(60))
            default: return priceArray
        }
    }

    func buyStock(symbol: String, quantity: Int) {
        myPortfolio[symbol, default: 0] += quantity
    }
}

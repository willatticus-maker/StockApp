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
        return getChartData(for: symbol, timeframe: timeframe).prices
    }


    func getChartData(for symbol: String, timeframe: String) -> (prices: [Double], dates: [String]) {
        guard let response = findInMatrix(symbol: symbol) else { return ([], []) }

        let sorted = response.sortedTimeSeries  // newest first
        let pairs: [(price: Double, date: String)] = sorted.compactMap { entry in
            guard let price = Double(entry.data.close) else { return nil }
            return (price, entry.date)
        }


        let reversed = pairs.reversed()

        let limited: [(price: Double, date: String)]
        switch timeframe {
        case "1W":  limited = Array(reversed.suffix(7))
        case "1M":  limited = Array(reversed.suffix(30))
        case "YTD": limited = Array(reversed.suffix(60))
        default:    limited = Array(reversed)   
        }

        return (limited.map { $0.price }, limited.map { $0.date })
    }

    func buyStock(symbol: String, quantity: Int) {
        myPortfolio[symbol, default: 0] += quantity
    }
}

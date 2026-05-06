import Foundation
import Combine

@Observable
class NetworkClient: ObservableObject {
    private(set) var stockCache: [String: AlphaVantageResponse] = [:]
       private(set) var isLoading = false
         
    private(set) var stockResponse: AlphaVantageResponse?
    func getBatchStocks(symbols: [String]) async {
            isLoading = true
            for symbol in symbols {
                if stockCache[symbol] != nil { continue }
                
                await getStockDetail(symbol: symbol)
                
                try? await Task.sleep(nanoseconds: 12_000_000_000)
            }
            isLoading = false
        }
    
    func getStockDetail(symbol:String) async {
        let urlStr = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&outputsize=compact&apikey=26YEL3PQC5ZHFB1P"
        
        guard let url = URL(string: urlStr) else { return }
        
        do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(AlphaVantageResponse.self, from: data)
                    
                    // Save to our dictionary
                    await MainActor.run {
                        self.stockCache[symbol] = response
                    }
                } catch {
                    print("Error fetching \(symbol): \(error)")
                }
            }
        }

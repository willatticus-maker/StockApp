import Foundation
import Combine

class NetworkClient: ObservableObject {
    
    @Published var stockPoints: [StockPoint] = []
    
    func getStockDetail() async {
        let urlStr = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=AAPL&outputsize=compact&apikey=26YEL3PQC5ZHFB1P"
        
        guard let url = URL(string: urlStr) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AlphaVantageResponse.self, from: data)
            
            let points = decoded.timeSeries.map { date, daily in
                StockPoint(
                    date: date,
                    open: Double(daily.open) ?? 0,
                    high: Double(daily.high) ?? 0,
                    low: Double(daily.low) ?? 0,
                    close: Double(daily.close) ?? 0,
                    volume: Double(daily.volume) ?? 0
                )
            }
            .sorted { $0.date < $1.date }
            
            await MainActor.run {
                self.stockPoints = points
            }
            
        } catch {
            print("Error:", error)
        }
    }
}

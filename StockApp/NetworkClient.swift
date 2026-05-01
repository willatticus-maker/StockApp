import Foundation
import Combine

@Observable
class NetworkClient: ObservableObject {
    
         
    private(set) var stockResponse: AlphaVantageResponse?
    
    func getStockDetail() async {
        let urlStr = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=AAPL&outputsize=compact&apikey=26YEL3PQC5ZHFB1P"
        
        guard let url = URL(string: urlStr) else { return }
        
        do {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let responseConverted = response as? HTTPURLResponse {
                stockResponse = try decoder.decode(AlphaVantageResponse.self, from: data)
                
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

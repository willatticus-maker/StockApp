import SwiftUI

struct PopularStocksView: View {
    @State private var network = NetworkClient()
    let popularSymbols = ["AAPL", "TSLA", "NVDA", "MSFT", "GOOGL"]
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.06, blue: 0.09), Color(red: 0.10, green: 0.12, blue: 0.18)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("POPULAR")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(popularSymbols, id: \.self) { symbol in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(symbol)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    if let price = network.stockCache[symbol]?.sortedTimeSeries.first?.data.close {
                                                   Text("$\(price)")
                                                       .font(.caption)
                                                       .foregroundColor(.cyan)
                                               } else {
                                                   Text("Loading...")
                                                       .font(.caption)
                                                       .foregroundColor(.white.opacity(0.4))
                                               }
                                           }
                                           
                                           Spacer()

                                           if let stockData = network.stockCache[symbol] {
                                               let chartValues = stockData.sortedTimeSeries.prefix(10)
                                                   .compactMap { Double($0.data.close) }
                                                   .reversed()
                                               
                                               GraphView(values: Array(chartValues))
                                                   .frame(width: 80, height: 40) // Give it a fixed size in the row
                                           }
                                       }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(18)
                            .onTapGesture {

                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
                let popularSymbols = ["AAPL", "TSLA", "NVDA", "MSFT", "GOOGL"]
                await network.getBatchStocks(symbols: popularSymbols)
            }
    }
}
            

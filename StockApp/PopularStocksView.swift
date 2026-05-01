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
                                    
                                    if network.stockResponse?.symbol == symbol {
                                        Text("$\(network.stockResponse?.sortedTimeSeries.first?.data.close ?? "---")")
                                            .font(.caption)
                                            .foregroundColor(.cyan)
                                    } else {
                                        Text("Tap to load price")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                                Spacer()
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.cyan)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(18)
                            .onTapGesture {
                                Task { await network.getStockDetail(symbol: symbol) }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
            

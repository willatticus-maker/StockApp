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
                            if let data = network.findInMatrix(symbol: symbol) {
                                NavigationLink(destination: StockDetailView(symbol: symbol, response: data)) {
                                    HStack {
                                        Text(symbol).font(.headline).foregroundColor(.white)
                                        Spacer()
                                        let prices = network.getPriceData(for: symbol, timeframe: "1W")
                                        GraphView(values: prices)
                                            .frame(width: 150, height: 50)
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.05)))
                                }
                            } else {
                                ProgressView().padding()
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
        .task {
                let popularSymbols = ["AAPL", "TSLA", "NVDA", "MSFT", "GOOGL"]
                await network.getBatchStocks(symbols: popularSymbols)
            }
    }
}
            

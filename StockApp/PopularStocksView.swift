import SwiftUI

struct PopularStocksView: View {
    @Environment(NetworkClient.self) private var network

    let popularSymbols = ["AAPL", "TSLA", "NVDA", "MSFT", "GOOGL"]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.06, blue: 0.09),
                        Color(red: 0.10, green: 0.12, blue: 0.18)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(alignment: .leading) {
                    Text("POPULAR")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(popularSymbols, id: \.self) { symbol in
                                NavigationLink(destination: StockDetailView(symbol: symbol)) {
                                    HStack {
                                        Text(symbol)
                                            .font(.headline)
                                            .foregroundColor(.white)

                                        Spacer()

                                        let prices = network.getPriceData(
                                            for: symbol,
                                            timeframe: "1W"
                                        )

                                        if prices.isEmpty {
                                            ProgressView()
                                                .tint(.white)
                                        } else {
                                            GraphView(values: prices)
                                                .frame(width: 150, height: 50)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.white.opacity(0.05))
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .task {
                await network.getBatchStocks(symbols: popularSymbols)
            }
        }
    }
}

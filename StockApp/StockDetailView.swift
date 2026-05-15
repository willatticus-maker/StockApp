//
//  StockDetailView.swift
//  StockApp
//
//  Created by Student on 5/6/26.
//

import SwiftUI

struct StockDetailView: View {
    @Environment(NetworkClient.self) private var network
    @Environment(PortfolioStore.self) private var portfolioStore
    let symbol: String
    @State private var selectedTimeframe = "1M"
    let timeframes = ["1W", "1M", "YTD", "1Y"]

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 25) {
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(timeframes, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                .padding()

                GraphView(values: network.getPriceData(for: symbol, timeframe: selectedTimeframe))
                    .frame(height: 300)
                    .padding()

                Button(action: {
                    let prices = network.getPriceData(for: symbol, timeframe: selectedTimeframe)
                    
                    if let latestPrice = network.getPriceData(for: symbol, timeframe: selectedTimeframe).last {
                        portfolioStore.buyStock(
                            symbol: symbol,
                            shares: 1,
                            price: latestPrice
                        )
                    }
                }) {
                    Text("BUY 1 SHARE OF \(symbol)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                
                Text("Owned: \(portfolioStore.sharesOwned(for: symbol), specifier: "%.2f") shares")
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
            }
        }
        .navigationTitle(symbol)
    }
}



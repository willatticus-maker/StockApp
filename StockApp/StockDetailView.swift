//
//  StockDetailView.swift
//  StockApp
//
//  Created by Student on 5/6/26.
//

import SwiftUI

struct StockDetailView: View {
    @Environment(NetworkClient.self) private var network
    let symbol: String
    @State private var selectedTimeframe = "1M"
    let timeframes = ["1W", "1M", "YTD", "1Y"]

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Timeframe Picker
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(timeframes, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                .padding()

                // High-Intensity Graph
                GraphView(values: network.getPriceData(for: symbol, timeframe: selectedTimeframe))
                    .frame(height: 300)

                    .padding()

                // Buy Button
                Button(action: {
                    network.buyStock(symbol: symbol, quantity: 1)
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
                
                // Show Current Holdings
                Text("Owned: \(network.myPortfolio[symbol] ?? 0) shares")
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
            }
        }
        .navigationTitle(symbol)
    }
}

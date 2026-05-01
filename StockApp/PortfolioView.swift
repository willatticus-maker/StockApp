//
//  PortfolioView.swift
//  StockApp
//
//  Created by Student on 4/30/26.
//
import SwiftUI

struct PortfolioView: View {
    // 1. Initialize your NetworkClient
    @State private var network = NetworkClient()
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.06, blue: 0.09), Color(red: 0.10, green: 0.12, blue: 0.18)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Portfolio Header Card
                VStack(alignment: .leading, spacing: 8) {
                    Text("TOTAL BALANCE")
                        .font(.caption)
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("$24,592.00")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "arrow.up.right")
                        Text("+5.2% Today")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
                }
                .padding(30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.1), lineWidth: 1))
                
                // Asset List
                VStack(alignment: .leading, spacing: 15) {
                    Text("YOUR ASSETS")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Live Asset Row
                    HStack {
                        Circle().fill(.orange).frame(width: 10, height: 10)
                        
                        VStack(alignment: .leading) {
                            Text("AAPL")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Text("12 Shares")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // 2. Display the live price from your network client
                        if let latestData = network.stockResponse?.sortedTimeSeries.first {
                            VStack(alignment: .trailing) {
                                Text("$\(latestData.data.close)")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                Text("Live")
                                    .font(.system(size: 10))
                                    .foregroundColor(.cyan)
                            }
                        } else {
                            // Loading state while API fetches
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(0.8)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                
                Spacer()
            }
            .padding(25)
        }
        // 3. Trigger the API call when the view appears
        .task {
            await network.getStockDetail(symbol:"")
        }
    }
}

#Preview {
    PortfolioView()
}

//
//  StockView.swift
//  StockApp
//
//  Created by Kevin Berfirer on 4/29/26.
//

import SwiftUI

struct StockPoint: Identifiable {
    let id = UUID()
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}

enum StockMetric: String, CaseIterable {
    case open = "Open"
    case high = "High"
    case low = "Low"
    case close = "Close"
    case volume = "Volume"
}

struct StockDashboardView: View {
    let stockData: [StockPoint]
    @State private var selectedMetric: StockMetric = .close
    
    var values: [Double] {
        stockData.map { point in
            switch selectedMetric {
            case .open: return point.open
            case .high: return point.high
            case .low: return point.low
            case .close: return point.close
            case .volume: return point.volume
            }
        }
    }
    
    var body: some View {
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Stock Dashboard")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Choose a metric to view its trend and daily data.")
                        .foregroundColor(.white.opacity(0.65))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 14) {
                        ForEach(StockMetric.allCases, id: \.self) { metric in
                            Button {
                                selectedMetric = metric
                            } label: {
                                Text(metric.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        selectedMetric == metric
                                        ? Color.blue.opacity(0.85)
                                        : Color.white.opacity(0.10)
                                    )
                                    .cornerRadius(16)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("\(selectedMetric.rawValue) Graph")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        GraphView(values: values)
                            .frame(height: 220)
                            .padding()
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(24)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(selectedMetric.rawValue) Data")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        ForEach(stockData) { point in
                            HStack {
                                Text(point.date)
                                    .foregroundColor(.white.opacity(0.75))
                                
                                Spacer()
                                
                                Text(displayValue(for: point))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(14)
                        }
                    }
                }
                .padding(28)
            }
        }
    }
    
    func displayValue(for point: StockPoint) -> String {
        let value: Double
        
        switch selectedMetric {
        case .open: value = point.open
        case .high: value = point.high
        case .low: value = point.low
        case .close: value = point.close
        case .volume: value = point.volume
        }
        
        if selectedMetric == .volume {
            return "\(Int(value))"
        } else {
            return "$\(String(format: "%.2f", value))"
        }
    }
}





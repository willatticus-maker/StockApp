//
//  Graphview.swift
//  StockApp
//
//  Created by Kevin Berfirer on 4/29/26.
//



import SwiftUI
struct GraphView: View {
    let values: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            if !values.isEmpty {
                let maxValue = values.max() ?? 1
                let minValue = values.min() ?? 0
                let range = maxValue - minValue == 0 ? 1 : maxValue - minValue
                
                Path { path in
                    for index in values.indices {
                        let denominator = max(values.count - 1, 1)
                        let x = geometry.size.width * CGFloat(index) / CGFloat(denominator)
                        let y = geometry.size.height - CGFloat((values[index] - minValue) / range) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.cyan, lineWidth: 4)
            } else {
                Color.clear
            }
        }
    }
}

//
//  Graphview.swift
//  StockApp
//
//  Created by Kevin Berfirer on 4/29/26.
//

import SwiftUI

struct GraphView: View {
    let values: [Double]
    let dates: [String]          // e.g. ["2025-04-01", "2025-04-02", ...]

    // Which index the user is currently scrubbing over (nil = no touch)
    @State private var scrubIndex: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            if values.isEmpty {
                Color.clear
            } else {
                let maxValue = values.max() ?? 1
                let minValue = values.min() ?? 0
                let range    = maxValue - minValue == 0 ? 1 : maxValue - minValue
                let width    = geometry.size.width
                let height   = geometry.size.height

                // Helper: converts a data index to an x position
                func xPos(_ index: Int) -> CGFloat {
                    let denom = max(values.count - 1, 1)
                    return width * CGFloat(index) / CGFloat(denom)
                }

                // Helper: converts a price value to a y position
                func yPos(_ value: Double) -> CGFloat {
                    // Leave 30pt at top for the callout label, 20pt at bottom for x-axis labels
                    let drawHeight = height - 50
                    let topPad: CGFloat = 30
                    return topPad + CGFloat(1 - (value - minValue) / range) * drawHeight
                }

                let isUp = (values.last ?? 0) >= (values.first ?? 0)
                let lineColor = isUp ? Color.green : Color.red

                ZStack(alignment: .topLeading) {

                    // ── Gradient fill under the line ─────────────────────
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yPos(values[0])))
                        for i in values.indices {
                            path.addLine(to: CGPoint(x: xPos(i), y: yPos(values[i])))
                        }
                        path.addLine(to: CGPoint(x: xPos(values.count - 1), y: height - 20))
                        path.addLine(to: CGPoint(x: 0, y: height - 20))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [lineColor.opacity(0.35), lineColor.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    // ── Main price line ───────────────────────────────────
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yPos(values[0])))
                        for i in values.indices {
                            path.addLine(to: CGPoint(x: xPos(i), y: yPos(values[i])))
                        }
                    }
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))

                    // ── Y-axis labels (min / mid / max) ───────────────────
                    let midValue = (maxValue + minValue) / 2
                    Group {
                        priceLabel("$\(formatPrice(maxValue))", y: yPos(maxValue) - 8)
                        priceLabel("$\(formatPrice(midValue))", y: yPos(midValue) - 8)
                        priceLabel("$\(formatPrice(minValue))", y: yPos(minValue) - 8)
                    }

                    // ── X-axis date labels ────────────────────────────────
                    if !dates.isEmpty {
                        Group {
                            Text(shortDate(dates.first ?? ""))
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.4))
                                .position(x: 26, y: height - 8)

                            Text(shortDate(dates.last ?? ""))
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.4))
                                .position(x: width - 26, y: height - 8)
                        }
                    }

                    // ── Scrubber (shown when dragging) ────────────────────
                    if let idx = scrubIndex, idx < values.count {
                        let scrubX = xPos(idx)
                        let scrubY = yPos(values[idx])

                        // Vertical line
                        Path { path in
                            path.move(to: CGPoint(x: scrubX, y: 28))
                            path.addLine(to: CGPoint(x: scrubX, y: height - 20))
                        }
                        .stroke(Color.white.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4]))

                        // Dot on the line
                        Circle()
                            .fill(lineColor)
                            .frame(width: 10, height: 10)
                            .position(x: scrubX, y: scrubY)

                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 10, height: 10)
                            .position(x: scrubX, y: scrubY)

                        // Price callout bubble
                        let price = values[idx]
                        let label = "$\(formatPrice(price))"
                        let dateLabel = idx < dates.count ? shortDate(dates[idx]) : ""
                        let bubbleX = min(max(scrubX, 50), width - 50)

                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            VStack(spacing: 1) {
                                Text(label)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text(dateLabel)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                        }
                        .fixedSize()
                        .position(x: bubbleX, y: 14)
                    }
                }
                // ── Drag gesture to scrub ─────────────────────────────────
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let denom = max(values.count - 1, 1)
                            let rawIndex = Int((value.location.x / width) * CGFloat(denom) + 0.5)
                            scrubIndex = max(0, min(rawIndex, values.count - 1))
                        }
                        .onEnded { _ in
                            scrubIndex = nil
                        }
                )
            }
        }
    }

    // Compact price: 183.42 → "183.42", no extra decimals
    private func formatPrice(_ value: Double) -> String {
        String(format: value >= 1000 ? "%.0f" : "%.2f", value)
    }

    // "2025-04-01" → "Apr 1"
    private func shortDate(_ raw: String) -> String {
        let parts = raw.split(separator: "-")
        guard parts.count == 3,
              let month = Int(parts[1]),
              let day   = Int(parts[2]) else { return raw }
        let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        guard month >= 1, month <= 12 else { return raw }
        return "\(months[month - 1]) \(day)"
    }

    private func priceLabel(_ text: String, y: CGFloat) -> some View {
        Text(text)
            .font(.system(size: 10))
            .foregroundColor(.white.opacity(0.4))
            .position(x: 26, y: y)
    }
}

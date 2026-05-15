import SwiftUI

struct GraphView: View {
    let values: [Double]
    let dates: [String]
    var isSimplified: Bool = false // Set to true for small list views

    @State private var scrubIndex: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            if values.isEmpty {
                Color.clear
            } else {
                let maxValue = values.max() ?? 1
                let minValue = values.min() ?? 0
                let range    = (maxValue - minValue == 0) ? 1 : (maxValue - minValue)
                let width    = geometry.size.width
                let height   = geometry.size.height
                let isUp     = (values.last ?? 0) >= (values.first ?? 0)
                let lineColor = isUp ? Color.green : Color.red

                ZStack(alignment: .topLeading) {

                    // ── Gradient fill under the line ─────────────────────
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yPos(values[0], height: height, min: minValue, range: range)))
                        for i in values.indices {
                            path.addLine(to: CGPoint(x: xPos(i, width: width), y: yPos(values[i], height: height, min: minValue, range: range)))
                        }
                        path.addLine(to: CGPoint(x: xPos(values.count - 1, width: width), y: height - (isSimplified ? 0 : 20)))
                        path.addLine(to: CGPoint(x: 0, y: height - (isSimplified ? 0 : 20)))
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
                        path.move(to: CGPoint(x: 0, y: yPos(values[0], height: height, min: minValue, range: range)))
                        for i in values.indices {
                            path.addLine(to: CGPoint(x: xPos(i, width: width), y: yPos(values[i], height: height, min: minValue, range: range)))
                        }
                    }
                    .stroke(lineColor, style: StrokeStyle(lineWidth: isSimplified ? 1.5 : 2.5, lineCap: .round, lineJoin: .round))

                    // ── Labels and Scrubber (Hidden if isSimplified is true) ──
                    if !isSimplified {
                        // Y-axis labels
                        let midValue = (maxValue + minValue) / 2
                        Group {
                            priceLabel("$\(formatPrice(maxValue))", y: yPos(maxValue, height: height, min: minValue, range: range) - 8)
                            priceLabel("$\(formatPrice(midValue))", y: yPos(midValue, height: height, min: minValue, range: range) - 8)
                            priceLabel("$\(formatPrice(minValue))", y: yPos(minValue, height: height, min: minValue, range: range) - 8)
                        }

                        // X-axis date labels
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

                        // Scrubber interaction
                        if let idx = scrubIndex, idx < values.count {
                            let scrubX = xPos(idx, width: width)
                            let scrubY = yPos(values[idx], height: height, min: minValue, range: range)

                            Path { path in
                                path.move(to: CGPoint(x: scrubX, y: 28))
                                path.addLine(to: CGPoint(x: scrubX, y: height - 20))
                            }
                            .stroke(Color.white.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4]))

                            Circle()
                                .fill(lineColor)
                                .frame(width: 10, height: 10)
                                .position(x: scrubX, y: scrubY)

                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 10, height: 10)
                                .position(x: scrubX, y: scrubY)

                            let price = values[idx]
                            let label = "$\(formatPrice(price))"
                            let dateLabel = idx < dates.count ? shortDate(dates[idx]) : ""
                            let bubbleX = min(max(scrubX, 50), width - 50)

                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.15))
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
                }
                .contentShape(Rectangle())
                .gesture(
                    isSimplified ? nil : DragGesture(minimumDistance: 0)
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

    // MARK: - Private Helpers

    private func xPos(_ index: Int, width: CGFloat) -> CGFloat {
        let denom = max(values.count - 1, 1)
        return width * CGFloat(index) / CGFloat(denom)
    }

    private func yPos(_ value: Double, height: CGFloat, min: Double, range: Double) -> CGFloat {
        // If simplified, use full height. If detailed, leave space for labels.
        let drawHeight = isSimplified ? height : height - 50
        let topPad: CGFloat = isSimplified ? 0 : 30
        return topPad + CGFloat(1 - (value - min) / range) * drawHeight
    }

    private func formatPrice(_ value: Double) -> String {
        String(format: value >= 1000 ? "%.0f" : "%.2f", value)
    }

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
            .position(x: 35, y: y)
    }
}

import SwiftUI

struct StockDetailView: View {
    @Environment(NetworkClient.self) private var network
    let symbol: String

    @State private var selectedTimeframe = "1M"
    @State private var quantity: Int = 1
    @State private var showConfirmation = false
    @State private var lastPurchaseQty: Int = 0

    let timeframes = ["1W", "1M", "YTD", "1Y"]

    // Latest closing price from the loaded stock data
    var currentPrice: Double? {
        guard let response = network.findInMatrix(symbol: symbol),
              let closeStr = response.sortedTimeSeries.first?.data.close else { return nil }
        return Double(closeStr)
    }

    var sharesOwned: Int {
        network.myPortfolio[symbol] ?? 0
    }

    var portfolioValue: Double? {
        guard let price = currentPrice else { return nil }
        return price * Double(sharesOwned)
    }

    var totalCost: Double? {
        guard let price = currentPrice else { return nil }
        return price * Double(quantity)
    }

    // Price change info
    var priceChange: (amount: Double, percent: Double, isUp: Bool)? {
        guard let response = network.findInMatrix(symbol: symbol),
              response.sortedTimeSeries.count >= 2 else { return nil }
        let today = Double(response.sortedTimeSeries[0].data.close) ?? 0
        let yesterday = Double(response.sortedTimeSeries[1].data.close) ?? 0
        guard yesterday != 0 else { return nil }
        let change = today - yesterday
        let pct = (change / yesterday) * 100
        return (change, pct, change >= 0)
    }

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.1).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // ── Price Header ──────────────────────────────────────
                    VStack(spacing: 6) {
                        if let price = currentPrice {
                            Text("$\(price, specifier: "%.2f")")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        } else {
                            ProgressView().tint(.white)
                        }

                        if let change = priceChange {
                            HStack(spacing: 6) {
                                Image(systemName: change.isUp ? "arrow.up.right" : "arrow.down.right")
                                Text("\(change.isUp ? "+" : "")\(change.amount, specifier: "%.2f") (\(change.isUp ? "+" : "")\(change.percent, specifier: "%.2f")%)")
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(change.isUp ? .green : .red)
                        }
                    }
                    .padding(.top, 8)

                    // ── Timeframe Picker ──────────────────────────────────
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(timeframes, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // ── Graph ─────────────────────────────────────────────
                    let chartData = network.getChartData(for: symbol, timeframe: selectedTimeframe)
                    GraphView(values: chartData.prices, dates: chartData.dates)
                        .frame(height: 220)
                        .padding(.horizontal)

                    // ── Your Holdings Card ────────────────────────────────
                    if sharesOwned > 0 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("YOUR POSITION")
                                .font(.caption.bold())
                                .tracking(2)
                                .foregroundColor(.white.opacity(0.5))

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(sharesOwned) shares")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    Text("Shares owned")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                if let value = portfolioValue {
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("$\(value, specifier: "%.2f")")
                                            .font(.title2.bold())
                                            .foregroundColor(.cyan)
                                        Text("Market value")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal)
                    }

                    // ── Buy Panel ─────────────────────────────────────────
                    VStack(spacing: 18) {
                        Text("BUY \(symbol)")
                            .font(.caption.bold())
                            .tracking(2)
                            .foregroundColor(.white.opacity(0.5))

                        // Quantity Stepper
                        VStack(spacing: 8) {
                            Text("Shares")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))

                            HStack(spacing: 24) {
                                Button {
                                    if quantity > 1 { quantity -= 1 }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(quantity > 1 ? .white : .white.opacity(0.25))
                                }
                                .disabled(quantity <= 1)

                                Text("\(quantity)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(minWidth: 60)
                                    .contentTransition(.numericText())
                                    .animation(.spring(response: 0.3), value: quantity)

                                Button {
                                    quantity += 1
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(.cyan)
                                }
                            }
                        }

                        // Order Summary
                        VStack(spacing: 0) {
                            orderRow(
                                label: "Price per share",
                                value: currentPrice.map { "$\(String(format: "%.2f", $0))" } ?? "—"
                            )
                            Divider().background(Color.white.opacity(0.1))
                            orderRow(
                                label: "Shares",
                                value: "\(quantity)"
                            )
                            Divider().background(Color.white.opacity(0.1))
                            orderRow(
                                label: "Estimated total",
                                value: totalCost.map { "$\(String(format: "%.2f", $0))" } ?? "—",
                                isTotal: true
                            )
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(14)

                        // Buy Button
                        Button {
                            lastPurchaseQty = quantity
                            network.buyStock(symbol: symbol, quantity: quantity)
                            withAnimation(.spring(response: 0.4)) {
                                showConfirmation = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation { showConfirmation = false }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                if showConfirmation {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Purchase Complete!")
                                } else {
                                    Text("Buy \(quantity) Share\(quantity == 1 ? "" : "s")")
                                    if let total = totalCost {
                                        Text("· $\(total, specifier: "%.2f")")
                                            .opacity(0.75)
                                    }
                                }
                            }
                            .font(.headline)
                            .foregroundColor(showConfirmation ? .white : .black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(showConfirmation ? Color.green : Color.cyan)
                            )
                        }
                        .animation(.spring(response: 0.3), value: showConfirmation)
                        .disabled(currentPrice == nil)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)

                    Spacer(minLength: 30)
                }
            }
        }
        .navigationTitle(symbol)
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func orderRow(label: String, value: String, isTotal: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(isTotal ? .subheadline.bold() : .subheadline)
                .foregroundColor(isTotal ? .white : .white.opacity(0.6))
            Spacer()
            Text(value)
                .font(isTotal ? .subheadline.bold() : .subheadline)
                .foregroundColor(isTotal ? .cyan : .white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

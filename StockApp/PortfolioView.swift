import SwiftUI

struct PortfolioView: View {
    @Environment(PortfolioStore.self) private var portfolioStore
    @State private var network = NetworkClient()

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

            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TOTAL BALANCE")
                        .font(.caption)
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.6))

                    Text("$\(portfolioStore.totalBalance, specifier: "%.2f")")
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
                    LinearGradient(
                        colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 15) {
                    Text("YOUR ASSETS")
                        .font(.headline)
                        .foregroundColor(.white)

                    ForEach(portfolioStore.holdings) { holding in
                        HStack {
                            Circle()
                                .fill(.orange)
                                .frame(width: 10, height: 10)

                            VStack(alignment: .leading) {
                                Text(holding.symbol)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)

                                Text("\(holding.shares, specifier: "%.2f") Shares")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("$\(holding.currentValue, specifier: "%.2f")")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)

                                Text("$\(holding.currentPrice, specifier: "%.2f") each")
                                    .font(.system(size: 10))
                                    .foregroundColor(.cyan)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }

                Spacer()
            }
            .padding(25)
        }
    }
}

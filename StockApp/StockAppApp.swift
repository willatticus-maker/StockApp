import SwiftUI

@main
struct StockAppApp: App {
    @State private var network = NetworkClient()
    @State private var portfolioStore = PortfolioStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(network)
                .environment(portfolioStore)
        }
    }
}

import SwiftUI

@main
struct StockAppApp: App {
    @State private var network = NetworkClient()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(network)
        }
    }
}

import SwiftUI

struct ContentView: View {
    
    @StateObject private var networkClient = NetworkClient()
    
    var body: some View {
        NavigationStack {
            HomeView(stockData: networkClient.stockPoints)
                .task {
                    await networkClient.getStockDetail()
                }
        }
    }
}

#Preview {
    ContentView()
}

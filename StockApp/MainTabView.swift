import SwiftUI


struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            
            PopularStocksView()
                .tabItem { Label("Markets", systemImage: "chart.bar") }
            
            PortfolioView()
                .tabItem { Label("Portfolio", systemImage: "briefcase") }
        }
        .tint(.cyan) // Colors the icons to match your theme
    }
}

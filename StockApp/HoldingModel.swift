import Foundation

struct Holding: Identifiable {
    let id = UUID()
    var symbol: String
    var shares: Double
    var currentPrice: Double

    var currentValue: Double {
        shares * currentPrice
    }
}

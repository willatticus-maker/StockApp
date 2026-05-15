import Foundation
import Observation

@Observable
class PortfolioStore {
    var cashBalance: Double = 0.0
    var holdings: [Holding] = []

    var totalStockValue: Double {
        holdings.reduce(0) { total, holding in
            total + holding.currentValue
        }
    }

    var totalBalance: Double {
        cashBalance + totalStockValue
    }
    
    func sharesOwned(for symbol: String) -> Double {
        holdings.first(where: { $0.symbol == symbol })?.shares ?? 0
    }
    func deposit(amount: Double) {
        cashBalance += amount
    }

    func withdraw(amount: Double) {
        cashBalance -= amount
    }

    func buyStock(symbol: String, shares: Double, price: Double) {
        let cost = shares * price

        guard cashBalance >= cost else {
            print("Not enough balance")
            return
        }

        cashBalance -= cost

        if let index = holdings.firstIndex(where: { $0.symbol == symbol }) {
            holdings[index].shares += shares
            holdings[index].currentPrice = price
        } else {
            let newHolding = Holding(symbol: symbol, shares: shares, currentPrice: price)
            holdings.append(newHolding)
        }
    }

    func sellStock(symbol: String, shares: Double, price: Double) {
        guard let index = holdings.firstIndex(where: { $0.symbol == symbol }) else {
            return
        }

        guard holdings[index].shares >= shares else {
            print("Not enough shares")
            return
        }

        holdings[index].shares -= shares
        cashBalance += shares * price

        if holdings[index].shares == 0 {
            holdings.remove(at: index)
        }
    }
}

//
//  PortfolioView.swift
//  StockApp
//
//  Created by Student on 4/30/26.
//


struct PortfolioView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.06, blue: 0.09), Color(red: 0.10, green: 0.12, blue: 0.18)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Portfolio Header Card
                VStack(alignment: .leading, spacing: 8) {
                    Text("TOTAL BALANCE")
                        .font(.caption)
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("$24,592.00")
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
                    LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.1), lineWidth: 1))
                
                // Asset List
                VStack(alignment: .leading) {
                    Text("YOUR ASSETS")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Example Asset Row
                    HStack {
                        Circle().fill(.orange).frame(width: 10, height: 10)
                        Text("AAPL")
                            .foregroundColor(.white)
                        Spacer()
                        Text("12 Shares")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                }
                Spacer()
            }
            .padding(25)
        }
    }
}

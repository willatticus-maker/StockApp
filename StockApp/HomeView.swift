import SwiftUI

struct HomeView: View {
    let stockData: [StockPoint]
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
            
            VStack( alignment: .leading, spacing: 28) {
                
                // Top section
                VStack(alignment: .leading, spacing: 10) {
                    Text("VANTAGE STOCKS")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("UPGRADE TO THE ULTIMATE INVESTING TOOLBOX")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.65))
                }
                
                // Abstract professional graphic
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 260)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 18
                        )
                        .frame(width: 150, height: 150)
                        .offset(x: -70, y: -25)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.9), .purple.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(18))
                        .offset(x: 80, y: 15)
                    
                    Capsule()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 180, height: 18)
                        .offset(x: 15, y: 95)
                    
                    Capsule()
                        .fill(Color.white.opacity(0.20))
                        .frame(width: 120, height: 18)
                        .offset(x: -15, y: 65)
                }
                
                Spacer()
                
                // Bottom card
                VStack(alignment: .leading, spacing: 12) {
                    Text("LETS GET IT")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("YEEE")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.65))
                        .lineSpacing(4)
                }
                .padding(22)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.07))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
            }
            .padding(28)
        }
    }
}



//
//  ContentView.swift
//  StockApp
//
//  Created by Will Fk on 4/24/26.
//


//API key: 26YEL3PQC5ZHFB1P
import SwiftUI

struct ContentView: View {
    
    @State private var networkClient = NetworkClient()
    @State private var apiData: String  = "p"
    var body: some View {
        HomePageView()
            .task{
                await networkClient.getStockDetail()

       
            }
        }
}

#Preview {
    ContentView()
}

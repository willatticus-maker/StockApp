//
//  ContentView.swift
//  StockApp
//
//  Created by Will Fk on 4/24/26.
//


//API key: 26YEL3PQC5ZHFB1P
import SwiftUI

struct ContentView: View {
    
    @Environment(NetworkClient.self) private var networkClient
    @State private var apiData: String  = "26YEL3PQC5ZHFB1P"
    var body: some View {
        ViewStockTest()
            .onAppear {
                print("appear")
            }
            .task{
                await networkClient.getStockDetail(symbol:"")
                print("done")

       
            }
        }
}

#Preview {
    ContentView()
        .environment(NetworkClient())
}

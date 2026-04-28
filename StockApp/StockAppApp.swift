//
//  StockAppApp.swift
//  StockApp
//
//  Created by Will Fk on 4/24/26.
//

import SwiftUI

@main
struct StockAppApp: App {
    @State private var networkClient = NetworkClient()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(networkClient)
            
            

        }
    }
}

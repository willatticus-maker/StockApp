//
//  ContentView.swift
//  StockApp
//
//  Created by Will Fk on 4/24/26.
//


//API key: 26YEL3PQC5ZHFB1P
import SwiftUI

struct ContentView: View {
    @State private var apiData: String  = "Placeholder"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(apiData)
            
            
                .task {
                    let urlStr = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&outputsize=10&apikey=26YEL3PQC5ZHFB1P"
                    let url: URL? = URL(string: urlStr)
                    guard let urlUnwrapped = url else {
                        return
                    }
                    do {
                        let (data, response) = try await URLSession.shared.data(from: urlUnwrapped)
                        if let responseConverted = response as? HTTPURLResponse {
                            print ("status code :\(responseConverted.statusCode )")
                            let printableData: String = String(decoding: data, as: UTF8.self)
                            print(printableData)
                        }
                    } catch let error {
                        print(error)
                    }
                    
                }
        
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

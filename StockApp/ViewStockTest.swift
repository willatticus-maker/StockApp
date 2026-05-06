//
//  ViewStockTest.swift
//  StockApp
//
//  Created by Will Fk on 4/29/26.
//

import SwiftUI
import Charts

struct ViewStockTest: View {
    @Environment(NetworkClient.self) private var networkClient
    
    
    struct StockCloseOverTime {
        
        var Date: Date
        var high : Double
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 10,height: 10)
            if let response = networkClient.stockResponse {
                Text ("evaluated")
                ForEach(response.sortedTimeSeries, id :\.date){item in
                    HStack{
                        Text(item.data.high)
                    }
                    
                }
               
                }
                
                
                
                
            
            }
        }
    }


#Preview {
    ViewStockTest()
        .environment(NetworkClient())
}

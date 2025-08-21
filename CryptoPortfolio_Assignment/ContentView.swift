//
//  ContentView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: TabBarItem = .analytics
    
    var body: some View {
        TabBarContainer(selection: $tabSelection) {
            PortfolioView()
                .tabBarItem(tab: .analytics, selection: $tabSelection)
            
            ExchangeView()
                .tabBarItem(tab: .exchange, selection: $tabSelection)
            
            RecordView()
                .tabBarItem(tab: .record, selection: $tabSelection)
            
            WalletView()
                .tabBarItem(tab: .wallet, selection: $tabSelection)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

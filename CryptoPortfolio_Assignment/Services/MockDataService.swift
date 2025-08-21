//
//  MockDataService.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    func getPortfolio() -> Portfolio {
        return Portfolio(
            totalValue: 157342.05,
            totalChange: 5234.12,
            totalChangePercentage: 3.4
        )
    }
    
    func getCryptoAssets() -> [CryptoAsset] {
        return [
            CryptoAsset(
                symbol: "BTC",
                name: "Bitcoin (BTC)",
                price: 7562502.14,
                priceChange: 23456.78,
                priceChangePercentage: 3.2,
                imageURL: nil
            ),
            CryptoAsset(
                symbol: "ETH",
                name: "Ether (ETH)",
                price: 179102.50,
                priceChange: 5567.89,
                priceChangePercentage: 3.2,
                imageURL: nil
            )
        ]
    }
    
    func getRecentTransactions() -> [Transaction] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            Transaction(
                type: .receive,
                cryptoSymbol: "BTC",
                amount: 0.002126,
                date: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                imageURL: nil
            ),
            Transaction(
                type: .receive,
                cryptoSymbol: "BTC",
                amount: 0.002126,
                date: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                imageURL: nil
            ),
            Transaction(
                type: .receive,
                cryptoSymbol: "BTC",
                amount: 0.002126,
                date: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                imageURL: nil
            )
        ]
    }
    
    func getChartData() -> [Double] {
        return [95.3, 162.57, 120.93, 156.16, 148.95, 181.79, 193.0]
    }
}
//
//  PortfolioViewModel.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import Foundation
import SwiftUI

class PortfolioViewModel: ObservableObject {
    @Published var portfolio: Portfolio
    @Published var cryptoAssets: [CryptoAsset] = []
    @Published var recentTransactions: [Transaction] = []
    @Published var selectedCurrency: CurrencyType = .inr
    @Published var selectedTimeframe: ChartTimeframe = .sixMonths
    @Published var chartData: [Double] = []
    
    private let mockDataService = MockDataService.shared
    
    init() {
        self.portfolio = mockDataService.getPortfolio()
        loadData()
    }
    
    func loadData() {
        cryptoAssets = mockDataService.getCryptoAssets()
        recentTransactions = mockDataService.getRecentTransactions()
        chartData = mockDataService.getChartData()
    }
    
    func toggleCurrency() {
        selectedCurrency = selectedCurrency == .inr ? .btc : .inr
    }
    
    func selectTimeframe(_ timeframe: ChartTimeframe) {
        selectedTimeframe = timeframe
        // In a real app, this would fetch new chart data
        chartData = mockDataService.getChartData()
    }
    
    var displayValue: String {
        switch selectedCurrency {
        case .inr:
            return portfolio.formattedTotalValue
        case .btc:
            // Convert INR to BTC (using approximate rate for demo)
            let btcValue = portfolio.totalValue / 7562502.14 // Using BTC price from mock data
            return "₿ \(String(format: "%.6f", btcValue))"
        }
    }
}
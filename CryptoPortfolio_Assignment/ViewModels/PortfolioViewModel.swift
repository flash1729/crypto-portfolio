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
    }
    
    var filteredChartData: [ChartDataPoint] {
        let allData = ChartDataPoint.mockData
        
        switch selectedTimeframe {
        case .oneHour:
            // Show last 3 data points for 1 hour view
            return Array(allData.suffix(3))
        case .eightHours:
            // Show last 8 data points for 8 hours view
            return Array(allData.suffix(8))
        case .oneDay:
            // Show last 24 data points for 1 day view (or available data)
            return Array(allData.suffix(min(24, allData.count)))
        case .oneWeek:
            // Show last 7 data points for 1 week view
            return Array(allData.suffix(7))
        case .oneMonth:
            // Show last 30 data points for 1 month view
            return Array(allData.suffix(min(30, allData.count)))
        case .sixMonths:
            // Show hardcoded 15 data points for 6 months view
            return Array(allData.suffix(15))
        case .oneYear:
            // Show all 30 data points for 1 year view
            return allData
        }
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
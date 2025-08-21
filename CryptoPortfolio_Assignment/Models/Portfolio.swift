//
//  Portfolio.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import Foundation

struct Portfolio: Codable {
    let totalValue: Double
    let totalChange: Double
    let totalChangePercentage: Double
    
    var formattedTotalValue: String {
        return "₹ \(String(format: "%.2f", totalValue))"
    }
    
    var formattedTotalChange: String {
        let sign = totalChangePercentage >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", totalChangePercentage))%"
    }
    
    var isPositiveChange: Bool {
        return totalChangePercentage >= 0
    }
}

enum CurrencyType: String, CaseIterable {
    case inr = "INR"
    case btc = "BTC"
    
    var symbol: String {
        switch self {
        case .inr: return "₹"
        case .btc: return "₿"
        }
    }
}

enum ChartTimeframe: String, CaseIterable {
    case oneHour = "1h"
    case eightHours = "8h"
    case oneDay = "1d"
    case oneWeek = "1w"
    case oneMonth = "1m"
    case sixMonths = "6m"
    case oneYear = "1y"
}
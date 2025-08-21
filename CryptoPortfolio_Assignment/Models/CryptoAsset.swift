//
//  CryptoAsset.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import Foundation

struct CryptoAsset: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let priceChange: Double
    let priceChangePercentage: Double
    let imageURL: String?
    
    var formattedPrice: String {
        return "₹ \(String(format: "%.2f", price))"
    }
    
    var formattedPriceChange: String {
        let sign = priceChangePercentage >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", priceChangePercentage))%"
    }
    
    var isPositiveChange: Bool {
        return priceChangePercentage >= 0
    }
}
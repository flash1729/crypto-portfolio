//
//  Transaction.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id = UUID()
    let type: TransactionType
    let cryptoSymbol: String
    let amount: Double
    let date: Date
    let imageURL: String?
    
    var formattedAmount: String {
        let sign = type == .receive ? "+" : "-"
        return "\(sign)\(String(format: "%.6f", amount))"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
}

enum TransactionType: String, CaseIterable, Codable {
    case receive = "Receive"
    case send = "Send"
    case exchange = "Exchange"
}
//
//  Number+Extensions.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 23/08/25.
//

import Foundation

extension Double {
    /// Formats the number according to Indian currency format
    /// Example: 1234567.89 -> "12,34,567.89"
    func formattedAsIndianCurrency(includeSymbol: Bool = true, decimalPlaces: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces
        
        // Format the number first
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? "0"
        
        // Convert to Indian numbering system (lakhs and crores)
        let indianFormatted = convertToIndianNumberFormat(formattedNumber)
        
        if includeSymbol {
            return "₹ \(indianFormatted)"
        } else {
            return indianFormatted
        }
    }
    
    /// Formats as currency for display in different contexts
    func formattedAsCurrency(currency: CurrencyType, decimalPlaces: Int = 2) -> String {
        switch currency {
        case .inr:
            return formattedAsIndianCurrency(includeSymbol: true, decimalPlaces: decimalPlaces)
        case .btc:
            return "₿ \(String(format: "%.\(decimalPlaces)f", self))"
        }
    }
    
    private func convertToIndianNumberFormat(_ formattedNumber: String) -> String {
        let components = formattedNumber.components(separatedBy: ".")
        let wholePart = components[0].replacingOccurrences(of: ",", with: "")
        let decimalPart = components.count > 1 ? components[1] : ""
        
        if wholePart.count <= 3 {
            // No formatting needed for numbers less than 1000
            return decimalPart.isEmpty ? wholePart : "\(wholePart).\(decimalPart)"
        }
        
        let digits = Array(wholePart.reversed())
        var result = ""
        
        // Add first 3 digits
        for i in 0..<min(3, digits.count) {
            result = String(digits[i]) + result
        }
        
        // Add remaining digits in groups of 2
        var i = 3
        while i < digits.count {
            let groupSize = min(2, digits.count - i)
            var group = ""
            for j in 0..<groupSize {
                group = String(digits[i + j]) + group
            }
            result = group + "," + result
            i += groupSize
        }
        
        return decimalPart.isEmpty ? result : "\(result).\(decimalPart)"
    }
}

extension Int {
    /// Formats the integer according to Indian currency format
    func formattedAsIndianCurrency(includeSymbol: Bool = true) -> String {
        return Double(self).formattedAsIndianCurrency(includeSymbol: includeSymbol, decimalPlaces: 0)
    }
}

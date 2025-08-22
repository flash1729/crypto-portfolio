//
//  TabBarItem.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

enum TabBarItem: String, CaseIterable, Hashable, Equatable {
    case analytics = "Analytics"
    case exchange = "Exchange"
    case record = "Record"
    case wallet = "Wallet"
    
    var iconName: String {
        switch self {
        case .analytics: return "analytics"
        case .exchange: return "exchange"
        case .record: return "record"
        case .wallet: return "wallet"
        }
    }
    
    var title: String {
        return self.rawValue
    }
    
    var color: Color {
        return Color.accentBlue
    }
}

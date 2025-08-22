//
//  TransactionRowView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct TransactionRowView: View {
    let iconName: String?
    let imageName: String?
    let title: String
    let date: String
    let currency: String
    let amount: String
    let backgroundColor: Color
    let useSystemIcon: Bool
    
    // Convenience initializer for Transaction model
    init(transaction: Transaction) {
        self.iconName = transaction.type == .receive ? nil : "arrow.2.squarepath"
        self.imageName = transaction.type == .receive ? transaction.cryptoSymbol.lowercased() : nil
        self.title = transaction.type.rawValue
        self.date = transaction.formattedDate
        self.currency = transaction.cryptoSymbol
        self.amount = transaction.formattedAmount
        self.backgroundColor = Color(red: 21/255, green: 21/255, blue: 21/255)
        self.useSystemIcon = false
    }
    
    // Flexible initializer for custom transaction rows
    init(
        iconName: String? = nil,
        imageName: String? = nil,
        title: String,
        date: String,
        currency: String,
        amount: String,
        backgroundColor: Color = Color(red: 21/255, green: 21/255, blue: 21/255),
        useSystemIcon: Bool = true
    ) {
        self.iconName = iconName
        self.imageName = imageName
        self.title = title
        self.date = date
        self.currency = currency
        self.amount = amount
        self.backgroundColor = backgroundColor
        self.useSystemIcon = useSystemIcon
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .frame(width: 48, height: 48)
            } else if let iconName = iconName, useSystemIcon {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: iconName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    )
            } else {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(currency.prefix(1))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            
            // Transaction Info
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text(date)
                    .font(.system(size: useSystemIcon ? 14 : 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(currency)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                
                Text(amount)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, useSystemIcon ? 20 : 12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: useSystemIcon ? 24 : 16))
    }
}
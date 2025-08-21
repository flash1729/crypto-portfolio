//
//  TransactionRowView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            if transaction.type == .receive {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(transaction.cryptoSymbol.prefix(1))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 72/255, green: 72/255, blue: 72/255))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "arrow.2.squarepath")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    )
            }
            
            // Transaction Info
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(transaction.type.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(transaction.formattedDate)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 111/255, green: 111/255, blue: 111/255))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(transaction.cryptoSymbol)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(transaction.formattedAmount)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color(red: 21/255, green: 21/255, blue: 21/255))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
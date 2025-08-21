//
//  CurrencyToggleView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct CurrencyToggleView: View {
    @Binding var selectedCurrency: CurrencyType
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // INR Toggle
            Button(action: {
                if selectedCurrency != .inr {
                    onToggle()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "dollarsign.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(selectedCurrency == .inr ? Color.black : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 40))
            }
            
            // BTC Toggle
            Button(action: {
                if selectedCurrency != .btc {
                    onToggle()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "bitcoinsign.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(selectedCurrency == .btc ? Color.black : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(.ultraThinMaterial)
                .opacity(0.6)
        )
    }
}
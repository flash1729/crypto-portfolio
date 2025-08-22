//
//  CurrencyToggleView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct CurrencyToggleView: View {
    @Binding var selectedCurrency: CurrencyType
    let onINRSelected: () -> Void
    let onBTCSelected: () -> Void
    let style: CurrencyToggleStyle
    
    enum CurrencyToggleStyle {
        case ultraThin
        case whiteBackground
    }
    
    init(
        selectedCurrency: Binding<CurrencyType>,
        onINRSelected: @escaping () -> Void,
        onBTCSelected: @escaping () -> Void,
        style: CurrencyToggleStyle = .ultraThin
    ) {
        self._selectedCurrency = selectedCurrency
        self.onINRSelected = onINRSelected
        self.onBTCSelected = onBTCSelected
        self.style = style
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // INR Toggle
            Button(action: onINRSelected) {
                toggleContent(for: .inr)
            }
            
            // BTC Toggle
            Button(action: onBTCSelected) {
                toggleContent(for: .btc)
            }
        }
        .background(backgroundView)
    }
    
    @ViewBuilder
    private func toggleContent(for currency: CurrencyType) -> some View {
        Group {
            if currency == .inr {
                if style == .whiteBackground {
                    Image("money")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .frame(width: 50, height: 38)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedCurrency == .inr ? Color.black : Color.clear)
                        )
                } else {
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
            } else {
                if style == .whiteBackground {
                    Text("₿")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedCurrency == .btc ? .white : .white.opacity(0.7))
                        .frame(width: 50, height: 38)
                        .background(selectedCurrency == .btc ? Color.black : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
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
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if style == .whiteBackground {
            Color.white.opacity(0.15)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
            RoundedRectangle(cornerRadius: 40)
                .fill(.ultraThinMaterial)
                .opacity(0.6)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CurrencyToggleView(
            selectedCurrency: .constant(.inr),
            onINRSelected: {},
            onBTCSelected: {},
            style: .ultraThin
        )
        
        CurrencyToggleView(
            selectedCurrency: .constant(.btc),
            onINRSelected: {},
            onBTCSelected: {},
            style: .whiteBackground
        )
    }
    .background(Color.black)
    .padding()
}
//
//  CryptoAssetRowView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct CryptoAssetRowView: View {
    let asset: CryptoAsset
    
    var body: some View {
        HStack(spacing: 24) {
            // Crypto Logo
            HStack {
                Circle()
                    .fill(asset.symbol == "BTC" ? 
                          Color.orange : 
                          Color.blue)
                    .frame(width: 42, height: 42)
                    .overlay(
                        Text(asset.symbol.prefix(1))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                Text(asset.name)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(Color(red: 252/255, green: 252/255, blue: 250/255, opacity: 0.8))
            }
            
            Spacer()
            
            // Price Info
            VStack(alignment: .trailing, spacing: 4) {
                Text(asset.formattedPrice)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 204/255, green: 204/255, blue: 203/255))
                
                Text(asset.formattedPriceChange)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(asset.isPositiveChange ? 
                                   Color(red: 17/255, green: 193/255, blue: 123/255) : 
                                   Color.red)
            }
        }
        .padding(16)
        .background(Color(red: 13/255, green: 12/255, blue: 13/255))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 21/255, green: 21/255, blue: 23/255),
                        Color(red: 43/255, green: 43/255, blue: 43/255),
                        Color(red: 21/255, green: 21/255, blue: 23/255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
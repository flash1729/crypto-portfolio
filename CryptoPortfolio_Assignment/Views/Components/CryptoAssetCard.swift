//
//  CryptoAssetCard.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct CryptoAssetCard: View {
    let imageName: String?
    let title: String
    let price: String
    let changePercentage: String
    let isPositiveChange: Bool
    let backgroundColor: Color
    let width: CGFloat
    let height: CGFloat
    
    init(
        imageName: String? = nil,
        title: String,
        price: String,
        changePercentage: String,
        isPositiveChange: Bool = true,
        backgroundColor: Color = Color(hex: "0D0C0D"),
        width: CGFloat = 204,
        height: CGFloat = 118
    ) {
        self.imageName = imageName
        self.title = title
        self.price = price
        self.changePercentage = changePercentage
        self.isPositiveChange = isPositiveChange
        self.backgroundColor = backgroundColor
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                // Icon or image
                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .frame(width: 42, height: 42)
                } else {
                    Circle()
                        .fill(.purple)
                        .frame(width: 42, height: 42)
                        .overlay(
                            Text("₳")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            // Price and percentage on same line
            HStack {
                Text(price)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(changePercentage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isPositiveChange ? .green : .red)
            }
        }
        .padding(16)
        .frame(width: width, height: height)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "151517"),
                            Color(hex: "2B2B2B"),
                            Color(hex: "151517")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }
}

#Preview {
    HStack(spacing: 24) {
        CryptoAssetCard(
            imageName: "btcVec",
            title: "Bitcoin (BTC)",
            price: "₹ 75,62,502.14",
            changePercentage: "+3.2%"
        )
        
        CryptoAssetCard(
            imageName: nil,
            title: "Cardano (ADA)",
            price: "₹ 45,234.67",
            changePercentage: "+1.8%"
        )
    }
    .background(Color.black)
    .padding()
}

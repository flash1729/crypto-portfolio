//
//  ExchangeDetailView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct ExchangeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var ethAmount: String = "2.640"
    @State private var inrAmount: Double = 465006.44
    @State private var isETHToINR: Bool = true // Track current exchange direction
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea(.all)
            
            // Background blur effect at bottom
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.black.opacity(0.12))
                    .frame(height: 122)
                    .blur(radius: 28)
                    .ignoresSafeArea(edges: .bottom)
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    // Top navigation
                    topNavigationBar
                    
                    Spacer(minLength: 20)
                    
                    // Cards with swap button overlay
                    ZStack {
                        VStack(spacing: 8) {
                            // ETH Card (Send)
                            CurrencyCard(
                                logoImage: isETHToINR ? "ether" : nil,
                                currencyCode: isETHToINR ? "ETH" : "INR",
                                actionText: isETHToINR ? "Send" : "Receive",
                                amount: isETHToINR ? ethAmount : inrAmount.formattedAsIndianCurrency(),
                                balance: isETHToINR ? "10.254" : 435804.0.formattedAsIndianCurrency(includeSymbol: false)
                            )
                            
                            // INR Card (Receive)
                            CurrencyCard(
                                logoImage: isETHToINR ? nil : "ether",
                                currencyCode: isETHToINR ? "INR" : "ETH",
                                actionText: isETHToINR ? "Receive" : "Send",
                                amount: isETHToINR ? inrAmount.formattedAsIndianCurrency() : ethAmount,
                                balance: isETHToINR ? 435804.0.formattedAsIndianCurrency(includeSymbol: false) : "10.254"
                            )
                        }
                        
                        // Swap button positioned between cards
                        swapButton
                            .offset(y: 0) // Centered between the cards
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Exchange button
                    exchangeButton
                    
                    Spacer(minLength: 20)
                    
                    // Transaction details
                    transactionDetails
                    
                    Spacer(minLength: 120)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
    private var topNavigationBar: some View {
        HStack(spacing: 24) {
            BackButton(action: {
                dismiss()
            })
            
            Text("Exchange")
                .font(.custom("Geist Mono Variable", size: 16))
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 44)
    }
    
    private var swapButton: some View {
        Button(action: {
            // Swap currencies
            withAnimation(.easeInOut(duration: 0.3)) {
                isETHToINR.toggle()
            }
        }) {
            ZStack {
                // Outer frame with inset shadows (52x52)
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "151517"))
                    .frame(width: 52, height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "151517"))
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            .shadow(color: .white.opacity(0.04), radius: 4, x: 0, y: -2)
                            .blendMode(.multiply)
                    )
                
                // Inner button with gradient fill (36x36)
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "151517"),
                                Color(hex: "0D0C0D")
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 36, height: 36)
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    .frame(width: 36, height: 36)
                
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
    
    private var exchangeButton: some View {
        PrimaryButton(
            title: "Exchange",
            action: {
                // Perform exchange
            }
        )
        .padding(.horizontal, 18)
    }
    
    private var transactionDetails: some View {
        VStack(spacing: 0) {
            // Rate
            HStack {
                Text("Rate")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.64))
                
                Spacer()
                
                Text(isETHToINR ? "1 ETH = \(176138.80.formattedAsIndianCurrency())" : "1 INR = 0.0000057 ETH")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 8)
            
            // Spread
            HStack {
                Text("Spread")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.64))
                
                Spacer()
                
                Text("0.2%")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 8)
            
            // Gas fee
            HStack {
                Text("Gas fee")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.64))
                
                Spacer()
                
                Text(422.73.formattedAsIndianCurrency())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 8)
            
            // You will receive
            HStack {
                Text("You will receive")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.64))
                
                Spacer()
                
                Text(isETHToINR ? 175716.07.formattedAsIndianCurrency() : "0.002635 ETH")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Reusable Currency Card Component
struct CurrencyCard: View {
    let logoImage: String?
    let currencyCode: String
    let actionText: String
    let amount: String
    let balance: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with logo and currency
            HStack(spacing: 16) {
                // Currency Logo
                if let logoImage = logoImage {
                    Image(logoImage)
                        .resizable()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.24))
                        .frame(width: 42, height: 42)
                        .overlay(
                            Image(systemName: "indianrupeesign")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
                
                // Currency selector
                HStack(spacing: 4) {
                    Text(currencyCode)
                        .font(.custom("Geist Mono Variable", size: 20))
                        .fontWeight(.regular)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.4))
                }
                
                Spacer()
                
                Text(actionText)
                    .font(.custom("Geist Mono Variable", size: 14))
                    .fontWeight(.regular)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 28)
            .padding(.top, 28)
            
            // Amount
            HStack {
                Text(amount)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            
            // Balance info
            HStack {
                Text("Balance")
                    .font(.custom("Geist Mono Variable", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.4))
                
                Spacer()
                
                Text(balance)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 4)
            .padding(.bottom, 20)
        }
        .background(Color(hex: "151517"))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ExchangeDetailView()
}

//
//  ExchangeView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct ExchangeView: View {
    @State private var showExchangeDetail = false
    
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    // Top navigation - same position as PortfolioView
                    topNavigationSection
                    
                    // Main content area
                    mainContentSection
                    
                    Spacer(minLength: 120) // Space for tab bar
                }
            }
            .scrollIndicators(.hidden)
        }
        .fullScreenCover(isPresented: $showExchangeDetail) {
            ExchangeDetailView()
        }
    }
    
    private var topNavigationSection: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 54) // Same as PortfolioView - account for status bar
    }
    
    private var mainContentSection: some View {
        VStack(spacing: 24) {
            // Background image with gradients - all stacked on top of each other
            ZStack {
                VStack {
                    ZStack {
                        // Third layer (bottom) - #111768
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "111768"))
                            .frame(width: 345, height: 177)
                            .offset(y: 16) // Push it down
                        
                        // Second layer (middle) - #2A1F7F
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "2A1F7F"))
                            .frame(width: 375, height: 177)
                            .offset(y: 8) // Push it down slightly
                        
                        // First layer (top) - Background image
                        Image("backgroundExchange")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 395, height: 177)
                            .rotationEffect(.degrees(90))
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .offset(y: 0)
                    }
                }
                
                // Content overlay
                VStack(spacing: 16) {
                    // INR badge - 46x34 dimensions
                    Text("INR")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 46, height: 34)
                        .background(Color.accentBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    // Main value
                    Text("1,57,342.05")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(.white)
                    
                    // Change indicators
                    HStack(spacing: 16) {
                        Text("₹ 1,342")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("+4.6%")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            
            // Action buttons with variable white borders
            HStack(spacing: 24) {
                // Up arrow button - gradient border on left side
                Button(action: {}) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(red: 0.102, green: 0.098, blue: 0.106), location: 0),
                                            .init(color: Color(red: 0.055, green: 0.055, blue: 0.063), location: 0.84)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            // Left side gradient border
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color.white, location: 0),
                                            .init(color: Color(hex: "999999").opacity(0), location: 0.74)
                                        ]),
                                        startPoint: .init(x: -0.6, y: 0.2), // 133.73deg equivalent
                                        endPoint: .init(x: 1.6, y: 0.8)
                                    ),
                                    lineWidth: 1
                                )
                                .mask(
                                    // Mask to show only left portion
                                    Circle()
                                        .frame(width: 50, height: 52)
                                        .offset(x: -11)
                                )
                        )
                }
                
                // Plus button - gradient border on top
                Button(action: {
                    showExchangeDetail = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(red: 0.102, green: 0.098, blue: 0.106), location: 0),
                                            .init(color: Color(red: 0.055, green: 0.055, blue: 0.063), location: 0.84)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            // Top gradient border
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color.white, location: 0),
                                            .init(color: Color(hex: "999999").opacity(0), location: 0.74)
                                        ]),
                                        startPoint: .init(x: -0.6, y: 0.2), // 133.73deg equivalent
                                        endPoint: .init(x: 1.6, y: 0.8)
                                    ),
                                    lineWidth: 1
                                )
                                .mask(
                                    // Mask to show only top portion
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .offset(y: -11)
                                )
                        )
                }
                
                // Down arrow button - gradient border on right side
                Button(action: {}) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(red: 0.102, green: 0.098, blue: 0.106), location: 0),
                                            .init(color: Color(red: 0.055, green: 0.055, blue: 0.063), location: 0.84)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            // Right side gradient border
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color.white, location: 0),
                                            .init(color: Color(hex: "999999").opacity(0), location: 0.74)
                                        ]),
                                        startPoint: .init(x: -0.6, y: 0.2), // 133.73deg equivalent
                                        endPoint: .init(x: 1.6, y: 0.8)
                                    ),
                                    lineWidth: 1
                                )
                                .mask(
                                    // Mask to show only right portion
                                    Circle()
                                        .frame(width: 55, height: 52)
                                        .offset(x: 11)
                                )
                        )
                }
            }
            .padding(.top, 16)
            
            // Transactions section
            transactionsSection
        }
    }
    
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Transactions")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text("Last 4 days")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            
            // Transaction list
            VStack(spacing: 8) {
                // Receive transaction
                transactionRow(
                    icon: "arrow.down",
                    title: "Recieve",
                    date: "20 March",
                    currency: "BTC",
                    amount: "+0.002126"
                )
                
                // Sent transaction
                transactionRow(
                    icon: "arrow.up",
                    title: "Sent",
                    date: "19 March",
                    currency: "ETH",
                    amount: "+0.003126"
                )
                
                // Send transaction
                transactionRow(
                    icon: "arrow.up",
                    title: "Send",
                    date: "18 March",
                    currency: "LTC",
                    amount: "+0.02126"
                )
                
                // Additional dummy transactions
                transactionRow(
                    icon: "arrow.down",
                    title: "Receive",
                    date: "17 March",
                    currency: "ADA",
                    amount: "+0.15432"
                )
                
                transactionRow(
                    icon: "arrow.up",
                    title: "Swap",
                    date: "16 March",
                    currency: "DOT",
                    amount: "+0.08765"
                )
                
                transactionRow(
                    icon: "arrow.down",
                    title: "Buy",
                    date: "15 March",
                    currency: "SOL",
                    amount: "+0.04321"
                )
            }
        }
        .padding(.top, 16)
    }
    
    private func transactionRow(icon: String, title: String, date: String, currency: String, amount: String) -> some View {
        HStack(spacing: 12) {
            // Icon
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                )
            
            // Title and date
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text(date)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Currency and amount
            VStack(alignment: .trailing, spacing: 2) {
                Text(currency)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                
                Text(amount)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 360, height: 84)
        .padding(.horizontal, 16)
        .background(Color(red: 21/255, green: 21/255, blue: 21/255, opacity: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ExchangeView()
}

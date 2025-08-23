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
        TopNavigationBar(
            menuAction: {},
            notificationAction: {}
        )
        .padding(.horizontal, 16) // Adjust positioning if needed
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
//                        Image("backgroundExchange")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 395, height: 177)
//                            .rotationEffect(.degrees(90))
//                            .clipped()
//                            .clipShape(RoundedRectangle(cornerRadius: 24))
//                            .offset(y: 0)
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(red: 0.25, green: 0.25, blue: 0.8), location: 0),  // Lighter blue-purple at start
                                .init(color: Color(red: 0.05, green: 0.05, blue: 0.25), location: 1)  // Darker navy blue at end
                            ]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        .frame(width: 395, height: 177)
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
                    Text(157342.05.formattedAsIndianCurrency(includeSymbol: false))
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(.white)
                    
                    // Change indicators
                    HStack(spacing: 16) {
                        Text(1342.0.formattedAsIndianCurrency())
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
                GradientActionButton(
                    iconName: "arrow.up",
                    action: { showExchangeDetail = true },
                    gradientPosition: .left
                )
                
                // Plus button - gradient border on top
                GradientActionButton(
                    iconName: "plus",
                    action: { showExchangeDetail = true },
                    gradientPosition: .top
                )
                
                // Down arrow button - gradient border on right side
                GradientActionButton(
                    iconName: "arrow.down",
                    action: { showExchangeDetail = true },
                    gradientPosition: .right
                )
            }
            .padding(.top, 16)
            
            // Transactions section
            transactionsSection
        }
    }
    
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(
                title: "Transactions",
                subtitle: "Last 4 days"
            )
            
            // Transaction list
            VStack(spacing: 8) {
                // Receive transaction
                TransactionRowView(
                    iconName: "arrow.down",
                    title: "Recieve",
                    date: "20 March",
                    currency: "BTC",
                    amount: "+0.002126",
                    backgroundColor: Color(red: 21/255, green: 21/255, blue: 21/255)
                )
                
                // Sent transaction
                TransactionRowView(
                    iconName: "arrow.up",
                    title: "Sent",
                    date: "19 March",
                    currency: "ETH",
                    amount: "+0.003126",
                    backgroundColor: Color(red: 21/255, green: 21/255, blue: 21/255)
                )
                
                // Send transaction
                TransactionRowView(
                    iconName: "arrow.up",
                    title: "Send",
                    date: "18 March",
                    currency: "LTC",
                    amount: "+0.02126",
                    backgroundColor: Color(red: 21/255, green: 21/255, blue: 21/255)
                )
                
                // Additional dummy transactions
                TransactionRowView(
                    iconName: "arrow.down",
                    title: "Receive",
                    date: "17 March",
                    currency: "ADA",
                    amount: "+0.15432",
                    backgroundColor: Color(red: 21/255, green: 21/255, blue: 21/255)
                )
                
                TransactionRowView(
                    iconName: "arrow.up",
                    title: "Swap",
                    date: "16 March",
                    currency: "DOT",
                    amount: "+0.08765",
                    backgroundColor: Color(red: 21/255, green: 21/255, blue: 21/255)
                )
                
                TransactionRowView(
                    iconName: "arrow.down",
                    title: "Buy",
                    date: "15 March",
                    currency: "SOL",
                    amount: "+0.04321",
                    backgroundColor: Color(red: 21/255, green: 21/255, blue: 21/255)
                )
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    ExchangeView()
}

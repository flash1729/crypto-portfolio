//
//  PortfolioView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct PortfolioView: View {
    @StateObject private var viewModel = PortfolioViewModel()
    
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with background image
                    headerSection
                    
                    // Chart section
                    chartSection
                    
                    // Crypto assets
                    cryptoAssetsSection
                    
                    // Recent transactions
                    recentTransactionsSection
                    
                    Spacer(minLength: 120)
                }
            }
            .ignoresSafeArea(edges: .top)
            .scrollIndicators(.hidden)
        }
    }
    
    private var headerSection: some View {
        ZStack {
            // Background image - rotated 180 degrees and extending to top
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400, height: 239) // Increased height to cover status bar area
                .rotationEffect(.degrees(180)) // Rotate 180 degrees
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
            // All content overlaid on the background image
            VStack(spacing: 0) {
                // Top navigation - positioned on the gradient background
                TopNavigationBar(
                    menuAction: {},
                    notificationAction: {}
                )
                .padding(.horizontal, 0) // Remove extra padding since TopNavigationBar handles it
                
                Spacer()
                
                // Portfolio value section - positioned on the gradient
                VStack(spacing: 16) {
                    HStack {
                        HStack(spacing: 4) {
                            Text("Portfolio Value")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        // Currency toggle - matching the design exactly
                        CurrencyToggleView(
                            selectedCurrency: $viewModel.selectedCurrency,
                            onINRSelected: { viewModel.selectCurrency(.inr) },
                            onBTCSelected: { viewModel.selectCurrency(.btc) },
                            style: .whiteBackground
                        )
                    }
                    
                    HStack {
                        Text(viewModel.displayValue)
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16) // Match navigation padding
                .padding(.bottom, 22) // More bottom padding since text is on gradient
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 0) // No top padding - start from very top
    }
    
    private var chartSection: some View {
        VStack(spacing: 16) {
            // Time period selector
            HStack(spacing: 12) {
                ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                    Button(action: {
                        viewModel.selectTimeframe(timeframe)
                    }) {
                        Text(timeframe.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(timeframe == viewModel.selectedTimeframe ? .white : .gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(timeframe == viewModel.selectedTimeframe ? Color.gray.opacity(0.3) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Chart area
            ChartView(data: viewModel.filteredChartData, currency: viewModel.selectedCurrency)
                .padding(.horizontal, 16)
        }
        .padding(.top, 16)
    }
    
    private var cryptoAssetsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) { // 24px gap as specified
                // Bitcoin card
                CryptoAssetCard(
                    imageName: "btcVec",
                    title: "Bitcoin (BTC)",
                    price: 7562502.14.formattedAsIndianCurrency(),
                    changePercentage: "+3.2%"
                )
                
                // Ethereum card
                CryptoAssetCard(
                    imageName: "ether",
                    title: "Ether (ETH)",
                    price: 179102.50.formattedAsIndianCurrency(),
                    changePercentage: "+3.2%"
                )
                
                // Cardano card
                CryptoAssetCard(
                    imageName: nil,
                    title: "Cardano (ADA)",
                    price: 45234.67.formattedAsIndianCurrency(),
                    changePercentage: "+1.8%"
                )
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 24)
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Recent Transactions")
            
            // First transaction row - Bitcoin Receive
            TransactionRowView(
                iconName: nil,
                imageName: "btcVec",
                title: "Recieve",
                date: "20 March",
                currency: "BTC",
                amount: "+0.002126",
                useSystemIcon: false
            )
            .padding(.horizontal, 16)
            
            // Second transaction row - Exchange
            TransactionRowView(
                iconName: nil,
                imageName: "ether",
                title: "Recieve",
                date: "20 March",
                currency: "BTC",
                amount: "+0.002126",
                useSystemIcon: false
            )
            .padding(.horizontal, 16)
        }
        .padding(.top, 32)
    }
    
    private var bottomTabBar: some View {
        VStack {
            Spacer()
            
            ZStack {
                // Soft gradient blur background that extends below
                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.4),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 200
                        )
                    )
                    .frame(height: 20)
//                    .blur(radius: 20)
                    .offset(y: 20)
                
                HStack(spacing: 16) {
                    // Custom rounded tab bar with glassmorphism
                    HStack(spacing: 0) {
                        // Analytics (selected) - using #222DEC color
                        VStack(spacing: 4) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("Analytics")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.accentBlue)
                        )
                        
                        // Exchange
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.2.squarepath")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("Exchange")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        
                        // Record
                        VStack(spacing: 4) {
                            Image(systemName: "chart.bar.doc.horizontal")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("Record")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        
                        // Wallet
                        VStack(spacing: 4) {
                            Image(systemName: "wallet.pass")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text("Wallet")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    )
                    
                    // Floating Plus Button (separate from tab bar)
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.accentBlue)
                            .frame(width: 62, height: 62)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20) // 20px from sides
                .padding(.bottom, 32) // 32px from bottom
            }
        }
    }
}

#Preview {
    PortfolioView()
}

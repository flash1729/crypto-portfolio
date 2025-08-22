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
                .padding(.horizontal, 16) // Increased horizontal padding to match design
                .padding(.top, 54) // Account for status bar
                
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
                        HStack(spacing: 0) {
                            Button(action: {
                                viewModel.toggleCurrency()
                            }) {
                                Image("money")
                                    .resizable()
                                    .frame(width: 18, height: 18) // Image frame
                                    .frame(width: 50, height: 38) // Expand to full frame
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(viewModel.selectedCurrency == .inr ? Color.black : Color.clear)
                                    )
                            }
                            
                            Button(action: {
                                viewModel.toggleCurrency()
                            }) {
                                Text("₿")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(viewModel.selectedCurrency == .btc ? .white : .white.opacity(0.7))
                                    .frame(width: 50, height: 38) // Fixed size for consistency
                                    .background(viewModel.selectedCurrency == .btc ? Color.black : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .background(Color.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
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
                VStack(alignment: .leading, spacing: 24) { // 24px gap between elements
                    HStack(spacing: 12) {
                        Image("btcVec")
                            .resizable()
                            .frame(width: 42, height: 42)
                            
                        
                        Text("Bitcoin (BTC)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    // Price and percentage on same line
                    HStack {
                        Text("₹ 75,62,502.14")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("+3.2%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                .padding(16) // 16px padding as specified
                .frame(width: 204, height: 118) // Exact dimensions from Figma
                .background(Color(hex: "0D0C0D")) // Background color from Figma
                .clipShape(RoundedRectangle(cornerRadius: 12)) // 12px radius
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
                            lineWidth: 2 // 2px border
                        )
                )
                
                // Ethereum card
                VStack(alignment: .leading, spacing: 24) { // 24px gap between elements
                    HStack(spacing: 12) {
                        Image("ether")
                            .resizable()
                            .frame(width: 42, height: 42)
                        
                        Text("Ether (ETH)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    // Price and percentage on same line
                    HStack {
                        Text("₹ 1,79,102.50")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("+3.2%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                .padding(16) // 16px padding as specified
                .frame(width: 204, height: 118) // Exact dimensions from Figma
                .background(Color(hex: "0D0C0D")) // Background color from Figma
                .clipShape(RoundedRectangle(cornerRadius: 12)) // 12px radius
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
                            lineWidth: 2 // 1px border
                        )
                )
                
                // Cardano card
                VStack(alignment: .leading, spacing: 24) { // 24px gap between elements
                    HStack(spacing: 12) {
                        Circle()
                            .fill(.purple)
                            .frame(width: 42, height: 42)
                            .overlay(
                                Text("₳")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Cardano (ADA)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    // Price and percentage on same line
                    HStack {
                        Text("₹ 45,234.67")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("+1.8%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                .padding(16) // 16px padding as specified
                .frame(width: 204, height: 118) // Exact dimensions from Figma
                .background(Color(hex: "0D0C0D")) // Background color from Figma
                .clipShape(RoundedRectangle(cornerRadius: 12)) // 12px radius
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
                            lineWidth: 2 // 2px border
                        )
                )
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 24)
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Transactions")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // First transaction row - Bitcoin Receive
            HStack(spacing: 12) {
                Image("btcVec")
                    .resizable()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recieve")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("20 March")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("BTC")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("+0.002126")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            
            // Second transaction row - Exchange
            HStack(spacing: 12) {
                Image("ether")
                    .resizable()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recieve")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("20 March")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("BTC")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("+0.002126")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
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

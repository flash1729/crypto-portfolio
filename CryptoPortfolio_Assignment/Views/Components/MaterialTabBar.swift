//
//  MaterialTabBar.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct MaterialTabBar: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            // Background blur that extends to actual bottom edge
            VStack(spacing: 0) {
                Spacer()
                
                ZStack {
                    // Accent color tint layer
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0),
                                    Color.accentBlue.opacity(0.25)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Transparent blur on top
                    TransparentBlurView(removeAllFilters: false)
                        .mask(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .frame(height: 200)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .allowsHitTesting(false)
            
            // Tab bar content anchored to bottom
            VStack {
                Spacer()
                
                HStack(spacing: 8) { // Fixed 8px spacing between tab bar and plus button
                    // Tab bar with glassmorphism - dynamic width based on plus button visibility
                    HStack(spacing: 0) {
                        ForEach(tabs, id: \.self) { tab in
                            tabView(tab: tab)
                        }
                    }
                    .padding(.horizontal, 4)
                    .frame(width: localSelection == .analytics ? 283 : 353, height: 63) // Dynamic width
                    .background(
                        RoundedRectangle(cornerRadius: 52) // Fixed corner radius
                            .fill(Color.black)
                    )
                    .padding(3)
                    .background(
                        RoundedRectangle(cornerRadius: 52) // Fixed corner radius
                            .fill(Color.black)
                    )
                    
                    // Floating Plus Button - only show when on Analytics tab
                    if localSelection == .analytics {
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.accentBlue)
                                .frame(width: 62, height: 62)
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: .black, radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 20) // Fixed 20px horizontal padding
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            localSelection = selection
        }
        .onChange(of: selection) { _, newValue in
            withAnimation(.bouncy(duration: 0.3)) {
                localSelection = newValue
            }
        }
    }
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack(spacing: 4) {
            Image(tab.iconName)
                .resizable()
                .frame(width: 24, height: 24)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(localSelection == tab ? .white : .gray)
            
            Text(tab.title)
                .font(.system(size: 10, weight: localSelection == tab ? .semibold : .medium))
                .foregroundColor(localSelection == tab ? .white : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Allow full height usage
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 44) // Fixed corner radius for inner rects
                        .fill(Color.accentBlue)
                        .frame(width: localSelection == .analytics ? 74 : 90, height: 55) // Dynamic width based on plus button
                        .matchedGeometryEffect(id: "tabHighlighting", in: namespace)
                }
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: 44))
        .onTapGesture {
            selection = tab
        }
    }
}

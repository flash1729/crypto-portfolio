//
//  SimpleChartView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct SimpleChartView: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background bars
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(0..<data.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 21/255, green: 21/255, blue: 21/255),
                                    Color(red: 8/255, green: 8/255, blue: 10/255)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(height: CGFloat(data[index]))
                    }
                }
                
                // Chart line
                Path { path in
                    let maxValue = data.max() ?? 1
                    let stepX = geometry.size.width / CGFloat(data.count - 1)
                    
                    for (index, value) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = geometry.size.height - (CGFloat(value) / CGFloat(maxValue)) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color(red: 17/255, green: 193/255, blue: 123/255), lineWidth: 1)
                
                // Pointer at specific position
                Circle()
                    .fill(Color(red: 252/255, green: 252/255, blue: 250/255))
                    .frame(width: 8, height: 8)
                    .position(x: geometry.size.width * 0.78, y: geometry.size.height * 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color(red: 252/255, green: 252/255, blue: 250/255), lineWidth: 1)
                            .frame(width: 15, height: 15)
                            .position(x: geometry.size.width * 0.78, y: geometry.size.height * 0.3)
                    )
                
                // Vertical line
                Rectangle()
                    .fill(Color(red: 252/255, green: 252/255, blue: 250/255))
                    .frame(width: 1, height: geometry.size.height)
                    .position(x: geometry.size.width * 0.78, y: geometry.size.height / 2)
                
                // Point annotation
                VStack(alignment: .trailing, spacing: 3) {
                    Text("24 March")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255, opacity: 0.4))
                    
                    Text(142340.0.formattedAsIndianCurrency())
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255, opacity: 0.8))
                }
                .position(x: geometry.size.width * 0.65, y: geometry.size.height * 0.15)
            }
        }
        .frame(height: 215)
    }
}
//
//  GradientActionButton.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct GradientActionButton: View {
    let iconName: String
    let action: () -> Void
    let gradientPosition: GradientPosition
    
    enum GradientPosition {
        case left, top, right
        
        var trimFrom: Double {
            switch self {
            case .left: return 0.25
            case .top: return 0.5
            case .right: return 0
            }
        }
        
        var trimTo: Double {
            switch self {
            case .left: return 0.75
            case .top: return 1
            case .right: return 0.5
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
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
                    Circle()
                        .trim(from: gradientPosition.trimFrom, to: gradientPosition.trimTo)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white, location: 0),
                                    .init(color: Color(hex: "999999").opacity(0), location: 0.74)
                                ]),
                                startPoint: .init(x: -0.6, y: 0.2),
                                endPoint: .init(x: 1.6, y: 0.8)
                            ),
                            style: StrokeStyle(lineWidth: 0.5, lineCap: .butt)
                        )
                )
        }
    }
}

#Preview {
    HStack(spacing: 24) {
        GradientActionButton(
            iconName: "arrow.up",
            action: {},
            gradientPosition: .left
        )
        
        GradientActionButton(
            iconName: "plus",
            action: {},
            gradientPosition: .top
        )
        
        GradientActionButton(
            iconName: "arrow.down",
            action: {},
            gradientPosition: .right
        )
    }
    .background(Color.black)
    .padding()
}

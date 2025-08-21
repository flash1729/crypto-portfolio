//
//  ChartView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct ChartView: View {
    let data: [ChartDataPoint]
    let currency: CurrencyType
    @State private var selectedIndex: Int?
    @State private var dragLocation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                backgroundGrid
                
                // Chart area
                chartArea(in: geometry)
                
                // Selected point indicator
                if let selectedIndex = selectedIndex {
                    selectedPointIndicator(at: selectedIndex, in: geometry)
                }
                
                // Drag overlay
                dragOverlay(in: geometry)
            }
        }
        .frame(height: 215)
    }
    
    private var backgroundGrid: some View {
        ZStack {
            // Horizontal grid lines
            VStack {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 0.5)
                    Spacer()
                }
            }
            
            // Vertical grid lines
            HStack {
                ForEach(0..<7, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 0.5)
                    Spacer()
                }
            }
        }
    }
    
    private func chartArea(in geometry: GeometryProxy) -> some View {
        ZStack {
            // Area fill
            areaPath(in: geometry)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.3),
                            Color.green.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Line chart
            linePath(in: geometry)
                .stroke(Color.green, lineWidth: 2)
        }
    }
    
    private func linePath(in geometry: GeometryProxy) -> Path {
        Path { path in
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(data.count - 1)
            
            let minValue = data.map(\.value).min() ?? 0
            let maxValue = data.map(\.value).max() ?? 1
            let valueRange = maxValue - minValue
            
            for (index, point) in data.enumerated() {
                let x = CGFloat(index) * stepX
                let normalizedValue = (point.value - minValue) / valueRange
                let y = height - (normalizedValue * height)
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
    }
    
    private func areaPath(in geometry: GeometryProxy) -> Path {
        Path { path in
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(data.count - 1)
            
            let minValue = data.map(\.value).min() ?? 0
            let maxValue = data.map(\.value).max() ?? 1
            let valueRange = maxValue - minValue
            
            // Start from bottom left
            path.move(to: CGPoint(x: 0, y: height))
            
            // Draw the line
            for (index, point) in data.enumerated() {
                let x = CGFloat(index) * stepX
                let normalizedValue = (point.value - minValue) / valueRange
                let y = height - (normalizedValue * height)
                
                if index == 0 {
                    path.addLine(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            // Close the path at bottom right
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
        }
    }
    
    private func selectedPointIndicator(at index: Int, in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let stepX = width / CGFloat(data.count - 1)
        let x = CGFloat(index) * stepX
        
        let minValue = data.map(\.value).min() ?? 0
        let maxValue = data.map(\.value).max() ?? 1
        let valueRange = maxValue - minValue
        let normalizedValue = (data[index].value - minValue) / valueRange
        let y = height - (normalizedValue * height)
        
        return ZStack {
            // Vertical line
            Rectangle()
                .fill(Color.white)
                .frame(width: 1)
                .position(x: x, y: height / 2)
            
            // Point circle
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 16, height: 16)
                )
                .position(x: x, y: y)
            
            // Value label
            VStack(spacing: 4) {
                Text(data[index].dateString)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(formatValue(data[index].value))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .position(
                x: x > 100 ? x - 60 : x + 60,
                y: 20
            )
        }
    }
    
    private func dragOverlay(in geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let width = geometry.size.width
                        let stepX = width / CGFloat(data.count - 1)
                        let index = Int(round(value.location.x / stepX))
                        
                        if index >= 0 && index < data.count {
                            selectedIndex = index
                        }
                        dragLocation = value.location
                    }
                    .onEnded { _ in
                        // Keep the selected point visible until another point is selected
                        // Don't reset selectedIndex to nil
                    }
            )
    }
    
    private func formatValue(_ value: Double) -> String {
        switch currency {
        case .inr:
            return "₹ \(String(format: "%.0f", value))"
        case .btc:
            // Convert INR to BTC using approximate rate
            let btcValue = value / 7562502.14 // Using BTC price from mock data
            return "₿ \(String(format: "%.6f", btcValue))"
        }
    }
}

struct ChartDataPoint {
    let value: Double
    let date: Date
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}

// Mock data for demonstration
extension ChartDataPoint {
    static let mockData: [ChartDataPoint] = [
        ChartDataPoint(value: 125340, date: Calendar.current.date(byAdding: .day, value: -29, to: Date()) ?? Date()),
        ChartDataPoint(value: 128200, date: Calendar.current.date(byAdding: .day, value: -28, to: Date()) ?? Date()),
        ChartDataPoint(value: 131900, date: Calendar.current.date(byAdding: .day, value: -27, to: Date()) ?? Date()),
        ChartDataPoint(value: 129500, date: Calendar.current.date(byAdding: .day, value: -26, to: Date()) ?? Date()),
        ChartDataPoint(value: 133200, date: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date()),
        ChartDataPoint(value: 130800, date: Calendar.current.date(byAdding: .day, value: -24, to: Date()) ?? Date()),
        ChartDataPoint(value: 135600, date: Calendar.current.date(byAdding: .day, value: -23, to: Date()) ?? Date()),
        ChartDataPoint(value: 132400, date: Calendar.current.date(byAdding: .day, value: -22, to: Date()) ?? Date()),
        ChartDataPoint(value: 138900, date: Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date()),
        ChartDataPoint(value: 141200, date: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date()),
        ChartDataPoint(value: 139800, date: Calendar.current.date(byAdding: .day, value: -19, to: Date()) ?? Date()),
        ChartDataPoint(value: 143500, date: Calendar.current.date(byAdding: .day, value: -18, to: Date()) ?? Date()),
        ChartDataPoint(value: 137200, date: Calendar.current.date(byAdding: .day, value: -17, to: Date()) ?? Date()),
        ChartDataPoint(value: 140600, date: Calendar.current.date(byAdding: .day, value: -16, to: Date()) ?? Date()),
        ChartDataPoint(value: 145800, date: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()),
        ChartDataPoint(value: 142300, date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()),
        ChartDataPoint(value: 148200, date: Calendar.current.date(byAdding: .day, value: -13, to: Date()) ?? Date()),
        ChartDataPoint(value: 151600, date: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date()),
        ChartDataPoint(value: 149800, date: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date()),
        ChartDataPoint(value: 153400, date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()),
        ChartDataPoint(value: 147900, date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date()),
        ChartDataPoint(value: 150200, date: Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? Date()),
        ChartDataPoint(value: 146800, date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()),
        ChartDataPoint(value: 142340, date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
        ChartDataPoint(value: 145200, date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()),
        ChartDataPoint(value: 138900, date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()),
        ChartDataPoint(value: 151200, date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
        ChartDataPoint(value: 148500, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
        ChartDataPoint(value: 155800, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
        ChartDataPoint(value: 157342, date: Date())
    ]
}

//extension ChartDataPoint {
//    static let mockData: [ChartDataPoint] = [
//        // Days -89 to -60 (30 days) - Early growth phase
//        ChartDataPoint(value: 87340, date: Calendar.current.date(byAdding: .day, value: -89, to: Date()) ?? Date()),
//        ChartDataPoint(value: 89200, date: Calendar.current.date(byAdding: .day, value: -88, to: Date()) ?? Date()),
//        ChartDataPoint(value: 88600, date: Calendar.current.date(byAdding: .day, value: -87, to: Date()) ?? Date()),
//        ChartDataPoint(value: 90800, date: Calendar.current.date(byAdding: .day, value: -86, to: Date()) ?? Date()),
//        ChartDataPoint(value: 92400, date: Calendar.current.date(byAdding: .day, value: -85, to: Date()) ?? Date()),
//        ChartDataPoint(value: 91200, date: Calendar.current.date(byAdding: .day, value: -84, to: Date()) ?? Date()),
//        ChartDataPoint(value: 93800, date: Calendar.current.date(byAdding: .day, value: -83, to: Date()) ?? Date()),
//        ChartDataPoint(value: 95600, date: Calendar.current.date(byAdding: .day, value: -82, to: Date()) ?? Date()),
//        ChartDataPoint(value: 94900, date: Calendar.current.date(byAdding: .day, value: -81, to: Date()) ?? Date()),
//        ChartDataPoint(value: 97200, date: Calendar.current.date(byAdding: .day, value: -80, to: Date()) ?? Date()),
//        ChartDataPoint(value: 96800, date: Calendar.current.date(byAdding: .day, value: -79, to: Date()) ?? Date()),
//        ChartDataPoint(value: 98400, date: Calendar.current.date(byAdding: .day, value: -78, to: Date()) ?? Date()),
//        ChartDataPoint(value: 100200, date: Calendar.current.date(byAdding: .day, value: -77, to: Date()) ?? Date()),
//        ChartDataPoint(value: 99600, date: Calendar.current.date(byAdding: .day, value: -76, to: Date()) ?? Date()),
//        ChartDataPoint(value: 101800, date: Calendar.current.date(byAdding: .day, value: -75, to: Date()) ?? Date()),
//        ChartDataPoint(value: 103400, date: Calendar.current.date(byAdding: .day, value: -74, to: Date()) ?? Date()),
//        ChartDataPoint(value: 102900, date: Calendar.current.date(byAdding: .day, value: -73, to: Date()) ?? Date()),
//        ChartDataPoint(value: 104600, date: Calendar.current.date(byAdding: .day, value: -72, to: Date()) ?? Date()),
//        ChartDataPoint(value: 106200, date: Calendar.current.date(byAdding: .day, value: -71, to: Date()) ?? Date()),
//        ChartDataPoint(value: 105800, date: Calendar.current.date(byAdding: .day, value: -70, to: Date()) ?? Date()),
//        ChartDataPoint(value: 107400, date: Calendar.current.date(byAdding: .day, value: -69, to: Date()) ?? Date()),
//        ChartDataPoint(value: 109100, date: Calendar.current.date(byAdding: .day, value: -68, to: Date()) ?? Date()),
//        ChartDataPoint(value: 108600, date: Calendar.current.date(byAdding: .day, value: -67, to: Date()) ?? Date()),
//        ChartDataPoint(value: 110800, date: Calendar.current.date(byAdding: .day, value: -66, to: Date()) ?? Date()),
//        ChartDataPoint(value: 112300, date: Calendar.current.date(byAdding: .day, value: -65, to: Date()) ?? Date()),
//        ChartDataPoint(value: 111900, date: Calendar.current.date(byAdding: .day, value: -64, to: Date()) ?? Date()),
//        ChartDataPoint(value: 113600, date: Calendar.current.date(byAdding: .day, value: -63, to: Date()) ?? Date()),
//        ChartDataPoint(value: 115200, date: Calendar.current.date(byAdding: .day, value: -62, to: Date()) ?? Date()),
//        ChartDataPoint(value: 114800, date: Calendar.current.date(byAdding: .day, value: -61, to: Date()) ?? Date()),
//        ChartDataPoint(value: 116400, date: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date()),
//        
//        // Days -59 to -30 (30 days) - Consolidation phase
//        ChartDataPoint(value: 118100, date: Calendar.current.date(byAdding: .day, value: -59, to: Date()) ?? Date()),
//        ChartDataPoint(value: 117600, date: Calendar.current.date(byAdding: .day, value: -58, to: Date()) ?? Date()),
//        ChartDataPoint(value: 119300, date: Calendar.current.date(byAdding: .day, value: -57, to: Date()) ?? Date()),
//        ChartDataPoint(value: 121000, date: Calendar.current.date(byAdding: .day, value: -56, to: Date()) ?? Date()),
//        ChartDataPoint(value: 120400, date: Calendar.current.date(byAdding: .day, value: -55, to: Date()) ?? Date()),
//        ChartDataPoint(value: 122200, date: Calendar.current.date(byAdding: .day, value: -54, to: Date()) ?? Date()),
//        ChartDataPoint(value: 121800, date: Calendar.current.date(byAdding: .day, value: -53, to: Date()) ?? Date()),
//        ChartDataPoint(value: 123500, date: Calendar.current.date(byAdding: .day, value: -52, to: Date()) ?? Date()),
//        ChartDataPoint(value: 122900, date: Calendar.current.date(byAdding: .day, value: -51, to: Date()) ?? Date()),
//        ChartDataPoint(value: 124600, date: Calendar.current.date(byAdding: .day, value: -50, to: Date()) ?? Date()),
//        ChartDataPoint(value: 126300, date: Calendar.current.date(byAdding: .day, value: -49, to: Date()) ?? Date()),
//        ChartDataPoint(value: 125800, date: Calendar.current.date(byAdding: .day, value: -48, to: Date()) ?? Date()),
//        ChartDataPoint(value: 127400, date: Calendar.current.date(byAdding: .day, value: -47, to: Date()) ?? Date()),
//        ChartDataPoint(value: 126900, date: Calendar.current.date(byAdding: .day, value: -46, to: Date()) ?? Date()),
//        ChartDataPoint(value: 128600, date: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date()),
//        ChartDataPoint(value: 130200, date: Calendar.current.date(byAdding: .day, value: -44, to: Date()) ?? Date()),
//        ChartDataPoint(value: 129700, date: Calendar.current.date(byAdding: .day, value: -43, to: Date()) ?? Date()),
//        ChartDataPoint(value: 131400, date: Calendar.current.date(byAdding: .day, value: -42, to: Date()) ?? Date()),
//        ChartDataPoint(value: 130900, date: Calendar.current.date(byAdding: .day, value: -41, to: Date()) ?? Date()),
//        ChartDataPoint(value: 132600, date: Calendar.current.date(byAdding: .day, value: -40, to: Date()) ?? Date()),
//        ChartDataPoint(value: 131800, date: Calendar.current.date(byAdding: .day, value: -39, to: Date()) ?? Date()),
//        ChartDataPoint(value: 133500, date: Calendar.current.date(byAdding: .day, value: -38, to: Date()) ?? Date()),
//        ChartDataPoint(value: 135100, date: Calendar.current.date(byAdding: .day, value: -37, to: Date()) ?? Date()),
//        ChartDataPoint(value: 134600, date: Calendar.current.date(byAdding: .day, value: -36, to: Date()) ?? Date()),
//        ChartDataPoint(value: 136300, date: Calendar.current.date(byAdding: .day, value: -35, to: Date()) ?? Date()),
//        ChartDataPoint(value: 135800, date: Calendar.current.date(byAdding: .day, value: -34, to: Date()) ?? Date()),
//        ChartDataPoint(value: 137400, date: Calendar.current.date(byAdding: .day, value: -33, to: Date()) ?? Date()),
//        ChartDataPoint(value: 136900, date: Calendar.current.date(byAdding: .day, value: -32, to: Date()) ?? Date()),
//        ChartDataPoint(value: 138600, date: Calendar.current.date(byAdding: .day, value: -31, to: Date()) ?? Date()),
//        ChartDataPoint(value: 140200, date: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()),
//        
//        // Days -29 to 0 (30 days) - Recent acceleration phase
//        ChartDataPoint(value: 125340, date: Calendar.current.date(byAdding: .day, value: -29, to: Date()) ?? Date()),
//        ChartDataPoint(value: 128200, date: Calendar.current.date(byAdding: .day, value: -28, to: Date()) ?? Date()),
//        ChartDataPoint(value: 131900, date: Calendar.current.date(byAdding: .day, value: -27, to: Date()) ?? Date()),
//        ChartDataPoint(value: 129500, date: Calendar.current.date(byAdding: .day, value: -26, to: Date()) ?? Date()),
//        ChartDataPoint(value: 133200, date: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date()),
//        ChartDataPoint(value: 130800, date: Calendar.current.date(byAdding: .day, value: -24, to: Date()) ?? Date()),
//        ChartDataPoint(value: 135600, date: Calendar.current.date(byAdding: .day, value: -23, to: Date()) ?? Date()),
//        ChartDataPoint(value: 132400, date: Calendar.current.date(byAdding: .day, value: -22, to: Date()) ?? Date()),
//        ChartDataPoint(value: 138900, date: Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date()),
//        ChartDataPoint(value: 141200, date: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date()),
//        ChartDataPoint(value: 139800, date: Calendar.current.date(byAdding: .day, value: -19, to: Date()) ?? Date()),
//        ChartDataPoint(value: 143500, date: Calendar.current.date(byAdding: .day, value: -18, to: Date()) ?? Date()),
//        ChartDataPoint(value: 137200, date: Calendar.current.date(byAdding: .day, value: -17, to: Date()) ?? Date()),
//        ChartDataPoint(value: 140600, date: Calendar.current.date(byAdding: .day, value: -16, to: Date()) ?? Date()),
//        ChartDataPoint(value: 145800, date: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()),
//        ChartDataPoint(value: 142300, date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()),
//        ChartDataPoint(value: 148200, date: Calendar.current.date(byAdding: .day, value: -13, to: Date()) ?? Date()),
//        ChartDataPoint(value: 151600, date: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date()),
//        ChartDataPoint(value: 149800, date: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date()),
//        ChartDataPoint(value: 153400, date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()),
//        ChartDataPoint(value: 147900, date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date()),
//        ChartDataPoint(value: 150200, date: Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? Date()),
//        ChartDataPoint(value: 146800, date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()),
//        ChartDataPoint(value: 142340, date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
//        ChartDataPoint(value: 145200, date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()),
//        ChartDataPoint(value: 138900, date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()),
//        ChartDataPoint(value: 151200, date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
//        ChartDataPoint(value: 148500, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
//        ChartDataPoint(value: 155800, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
//        ChartDataPoint(value: 157342, date: Date())
//    ]
//}
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            ChartView(data: ChartDataPoint.mockData, currency: .inr)
                .padding()
            
            Spacer()
        }
    }
}

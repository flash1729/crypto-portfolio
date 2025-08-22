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
            
            // Convert data points to CGPoints
            var points: [CGPoint] = []
            for (index, point) in data.enumerated() {
                let x = CGFloat(index) * stepX
                let normalizedValue = (point.value - minValue) / valueRange
                let y = height - (normalizedValue * height)
                points.append(CGPoint(x: x, y: y))
            }
            
            guard points.count > 1 else { return }
            
            // Start at first point
            path.move(to: points[0])
            
            // Create smooth curves between points
            for i in 1..<points.count {
                let currentPoint = points[i]
                let previousPoint = points[i - 1]
                
                // Calculate control points for smooth curve
                let controlPoint1: CGPoint
                let controlPoint2: CGPoint
                
                if i == 1 {
                    // First curve
                    controlPoint1 = CGPoint(
                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
                        y: previousPoint.y
                    )
                    controlPoint2 = CGPoint(
                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
                        y: currentPoint.y
                    )
                } else if i == points.count - 1 {
                    // Last curve
                    controlPoint1 = CGPoint(
                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
                        y: previousPoint.y
                    )
                    controlPoint2 = CGPoint(
                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
                        y: currentPoint.y
                    )
                } else {
                    // Middle curves - use neighboring points for smoother transitions
                    let nextPoint = points[i + 1]
                    let prevPrevPoint = points[i - 2]
                    
                    controlPoint1 = CGPoint(
                        x: previousPoint.x + (currentPoint.x - prevPrevPoint.x) * 0.15,
                        y: previousPoint.y + (currentPoint.y - prevPrevPoint.y) * 0.15
                    )
                    controlPoint2 = CGPoint(
                        x: currentPoint.x - (nextPoint.x - previousPoint.x) * 0.15,
                        y: currentPoint.y - (nextPoint.y - previousPoint.y) * 0.15
                    )
                }
                
                // Add cubic curve
                path.addCurve(
                    to: currentPoint,
                    control1: controlPoint1,
                    control2: controlPoint2
                )
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
            
            // Convert data points to CGPoints
            var points: [CGPoint] = []
            for (index, point) in data.enumerated() {
                let x = CGFloat(index) * stepX
                let normalizedValue = (point.value - minValue) / valueRange
                let y = height - (normalizedValue * height)
                points.append(CGPoint(x: x, y: y))
            }
            
            guard points.count > 1 else { return }
            
            // Start from bottom left
            path.move(to: CGPoint(x: 0, y: height))
            
            // Move to first point
            path.addLine(to: points[0])
            
            // Create smooth curves between points (same logic as linePath)
            for i in 1..<points.count {
                let currentPoint = points[i]
                let previousPoint = points[i - 1]
                
                // Calculate control points for smooth curve
                let controlPoint1: CGPoint
                let controlPoint2: CGPoint
                
                if i == 1 {
                    // First curve
                    controlPoint1 = CGPoint(
                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
                        y: previousPoint.y
                    )
                    controlPoint2 = CGPoint(
                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
                        y: currentPoint.y
                    )
                } else if i == points.count - 1 {
                    // Last curve
                    controlPoint1 = CGPoint(
                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
                        y: previousPoint.y
                    )
                    controlPoint2 = CGPoint(
                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
                        y: currentPoint.y
                    )
                } else {
                    // Middle curves - use neighboring points for smoother transitions
                    let nextPoint = points[i + 1]
                    let prevPrevPoint = points[i - 2]
                    
                    controlPoint1 = CGPoint(
                        x: previousPoint.x + (currentPoint.x - prevPrevPoint.x) * 0.15,
                        y: previousPoint.y + (currentPoint.y - prevPrevPoint.y) * 0.15
                    )
                    controlPoint2 = CGPoint(
                        x: currentPoint.x - (nextPoint.x - previousPoint.x) * 0.15,
                        y: currentPoint.y - (nextPoint.y - previousPoint.y) * 0.15
                    )
                }
                
                // Add cubic curve
                path.addCurve(
                    to: currentPoint,
                    control1: controlPoint1,
                    control2: controlPoint2
                )
            }
            
            // Close the path at bottom right
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
        }
    }
    
    private func selectedPointIndicator(at index: Int, in geometry: GeometryProxy) -> some View {
        // Safely check if index is within bounds
        guard index >= 0 && index < data.count else {
            return AnyView(EmptyView())
        }
        
        let width = geometry.size.width
        let height = geometry.size.height
        let stepX = width / CGFloat(data.count - 1)
        let x = CGFloat(index) * stepX
        
        let minValue = data.map(\.value).min() ?? 0
        let maxValue = data.map(\.value).max() ?? 1
        let valueRange = maxValue - minValue
        
        // Safely access the data point
        let dataPoint = data[index]
        let normalizedValue = valueRange > 0 ? (dataPoint.value - minValue) / valueRange : 0
        let y = height - (normalizedValue * height)
        
        return AnyView(
            ZStack {
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
                    Text(dataPoint.dateString)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text(formatValue(dataPoint.value))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                .position(
                    x: x > 100 ? x - 60 : x + 60,
                    y: 20
                )
            }
        )
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
                        let newIndex = Int(round(value.location.x / stepX))
                        
                        if newIndex >= 0 && newIndex < data.count {
                            // Only trigger haptic feedback if we've moved to a different point
                            if selectedIndex != newIndex {
                                selectedIndex = newIndex
                                
                                // Add subtle haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                impactFeedback.prepare()
                                impactFeedback.impactOccurred()
                            }
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

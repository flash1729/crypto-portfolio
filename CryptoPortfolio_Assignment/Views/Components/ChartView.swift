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
            // Area fill with gradient based on overall trend
            areaPath(in: geometry)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            overallTrendColor.opacity(0.3),
                            overallTrendColor.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Multi-colored line segments
            coloredLineSegments(in: geometry)
        }
    }
    
    private var overallTrendColor: Color {
        guard let firstValue = data.first?.value,
              let lastValue = data.last?.value else { return .green }
        return lastValue >= firstValue ? .green : .red
    }
    
    private func coloredLineSegments(in geometry: GeometryProxy) -> some View {
        ZStack {
            ForEach(0..<max(0, data.count - 1), id: \.self) { index in
                segmentPath(from: index, to: index + 1, in: geometry)
                    .stroke(colorForSegment(from: index, to: index + 1), lineWidth: 2)
            }
        }
    }
    
    private func colorForSegment(from startIndex: Int, to endIndex: Int) -> Color {
        guard startIndex < data.count && endIndex < data.count else { return .green }
        
        let startValue = data[startIndex].value
        let endValue = data[endIndex].value
        
        return endValue >= startValue ? .green : .red
    }
    
    private func segmentPath(from startIndex: Int, to endIndex: Int, in geometry: GeometryProxy) -> Path {
        Path { path in
            guard startIndex < data.count && endIndex < data.count else { return }
            
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(data.count - 1)
            
            let minValue = data.map(\.value).min() ?? 0
            let maxValue = data.map(\.value).max() ?? 1
            let valueRange = maxValue - minValue
            
            // Get points for this segment
            let startPoint = data[startIndex]
            let endPoint = data[endIndex]
            
            let startX = CGFloat(startIndex) * stepX
            let endX = CGFloat(endIndex) * stepX
            
            let startNormalizedValue = (startPoint.value - minValue) / valueRange
            let endNormalizedValue = (endPoint.value - minValue) / valueRange
            
            let startY = height - (startNormalizedValue * height)
            let endY = height - (endNormalizedValue * height)
            
            let startCGPoint = CGPoint(x: startX, y: startY)
            let endCGPoint = CGPoint(x: endX, y: endY)
            
            // Start at first point
            path.move(to: startCGPoint)
            
            // Calculate control points for smooth curve
            let controlPoint1 = CGPoint(
                x: startX + (endX - startX) * 0.3,
                y: startY
            )
            let controlPoint2 = CGPoint(
                x: endX - (endX - startX) * 0.3,
                y: endY
            )
            
            // Add cubic curve
            path.addCurve(
                to: endCGPoint,
                control1: controlPoint1,
                control2: controlPoint2
            )
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
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentBlue, lineWidth: 1)
                        )
                )
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
            return value.formattedAsIndianCurrency(includeSymbol: true, decimalPlaces: 0)
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

////
////  ChartView.swift
////  CryptoPortfolio_Assignment
////
////  Created by Aditya Medhane on 22/08/25.
////
//
//import SwiftUI
//
//struct ChartView: View {
//    let data: [ChartDataPoint]
//    let currency: CurrencyType
//    @State private var selectedIndex: Int?
//    @State private var dragLocation: CGPoint = .zero
//    @State private var animationProgress: Double = 0.0
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // Background grid
//                backgroundGrid
//                
//                // Chart area
//                chartArea(in: geometry)
//                
//                // Selected point indicator
//                if let selectedIndex = selectedIndex {
//                    selectedPointIndicator(at: selectedIndex, in: geometry)
//                }
//                
//                // Drag overlay
//                dragOverlay(in: geometry)
//            }
//        }
//        .frame(height: 215)
//        .onAppear {
//            withAnimation(.easeInOut(duration: 1.5)) {
//                animationProgress = 1.0
//            }
//        }
//    }
//    
//    private var backgroundGrid: some View {
//        ZStack {
//            // Horizontal grid lines
//            VStack {
//                ForEach(0..<5, id: \.self) { _ in
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.1))
//                        .frame(height: 0.5)
//                    Spacer()
//                }
//            }
//            
//            // Vertical grid lines
//            HStack {
//                ForEach(0..<7, id: \.self) { _ in
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.1))
//                        .frame(width: 0.5)
//                    Spacer()
//                }
//            }
//        }
//    }
//    
//    private func chartArea(in geometry: GeometryProxy) -> some View {
//        ZStack {
//            // Area fill with dynamic gradient
//            areaPath(in: geometry)
//                .fill(dynamicGradient)
//                .opacity(animationProgress)
//            
//            // Line chart with dynamic color segments
//            dynamicColorLinePath(in: geometry)
//        }
//    }
//    
//    private var dynamicGradient: LinearGradient {
//        let isOverallPositive = (data.last?.value ?? 0) >= (data.first?.value ?? 0)
//        let baseColor = isOverallPositive ? Color.green : Color.red
//        
//        return LinearGradient(
//            gradient: Gradient(colors: [
//                baseColor.opacity(0.3),
//                baseColor.opacity(0.1),
//                Color.clear
//            ]),
//            startPoint: .top,
//            endPoint: .bottom
//        )
//    }
//    
//    private func dynamicColorLinePath(in geometry: GeometryProxy) -> some View {
//        ZStack {
//            ForEach(0..<max(0, data.count - 1), id: \.self) { index in
//                segmentPath(from: index, to: index + 1, in: geometry)
//                    .trim(from: 0, to: animationProgress)
//                    .stroke(
//                        segmentColor(from: index, to: index + 1),
//                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
//                    )
//                    .animation(.easeInOut(duration: 1.5).delay(Double(index) * 0.1), value: animationProgress)
//            }
//        }
//    }
//    
//    private func segmentColor(from startIndex: Int, to endIndex: Int) -> Color {
//        guard startIndex < data.count && endIndex < data.count else { return .green }
//        
//        let startValue = data[startIndex].value
//        let endValue = data[endIndex].value
//        
//        return endValue >= startValue ? .green : .red
//    }
//    
//    private func segmentPath(from startIndex: Int, to endIndex: Int, in geometry: GeometryProxy) -> Path {
//        Path { path in
//            let width = geometry.size.width
//            let height = geometry.size.height
//            let stepX = width / CGFloat(data.count - 1)
//            
//            let minValue = data.map(\.value).min() ?? 0
//            let maxValue = data.map(\.value).max() ?? 1
//            let valueRange = maxValue - minValue
//            
//            guard startIndex < data.count && endIndex < data.count else { return }
//            
//            // Calculate points
//            let startPoint = calculatePoint(for: startIndex, stepX: stepX, height: height, minValue: minValue, valueRange: valueRange)
//            let endPoint = calculatePoint(for: endIndex, stepX: stepX, height: height, minValue: minValue, valueRange: valueRange)
//            
//            path.move(to: startPoint)
//            
//            // Create smooth curve with original control points (same as original implementation)
//            let controlPoint1: CGPoint
//            let controlPoint2: CGPoint
//            
//            if startIndex == 0 {
//                // First curve
//                controlPoint1 = CGPoint(
//                    x: startPoint.x + (endPoint.x - startPoint.x) * 0.3,
//                    y: startPoint.y
//                )
//                controlPoint2 = CGPoint(
//                    x: endPoint.x - (endPoint.x - startPoint.x) * 0.3,
//                    y: endPoint.y
//                )
//            } else if endIndex == data.count - 1 {
//                // Last curve
//                controlPoint1 = CGPoint(
//                    x: startPoint.x + (endPoint.x - startPoint.x) * 0.3,
//                    y: startPoint.y
//                )
//                controlPoint2 = CGPoint(
//                    x: endPoint.x - (endPoint.x - startPoint.x) * 0.3,
//                    y: endPoint.y
//                )
//            } else {
//                // Middle curves - use neighboring points for smoother transitions
//                let nextPoint = calculatePoint(for: endIndex + 1, stepX: stepX, height: height, minValue: minValue, valueRange: valueRange)
//                let prevPrevPoint = calculatePoint(for: startIndex - 1, stepX: stepX, height: height, minValue: minValue, valueRange: valueRange)
//                
//                controlPoint1 = CGPoint(
//                    x: startPoint.x + (endPoint.x - prevPrevPoint.x) * 0.15,
//                    y: startPoint.y + (endPoint.y - prevPrevPoint.y) * 0.15
//                )
//                controlPoint2 = CGPoint(
//                    x: endPoint.x - (nextPoint.x - startPoint.x) * 0.15,
//                    y: endPoint.y - (nextPoint.y - startPoint.y) * 0.15
//                )
//            }
//            
//            path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
//        }
//    }
//    
//    private func calculateCurvePosition(at index: Int, stepX: CGFloat, height: CGFloat, minValue: Double, valueRange: Double) -> CGPoint {
//        // For data points, we want the exact position which is the original data point position
//        // since the curve passes through these points
//        let x = CGFloat(index) * stepX
//        let normalizedValue = valueRange > 0 ? (data[index].value - minValue) / valueRange : 0
//        let y = height - (normalizedValue * height)
//        return CGPoint(x: x, y: y)
//    }
//    
//    private func calculatePoint(for index: Int, stepX: CGFloat, height: CGFloat, minValue: Double, valueRange: Double) -> CGPoint {
//        let x = CGFloat(index) * stepX
//        let normalizedValue = valueRange > 0 ? (data[index].value - minValue) / valueRange : 0
//        let y = height - (normalizedValue * height)
//        return CGPoint(x: x, y: y)
//    }
//    
//    private func linePath(in geometry: GeometryProxy) -> Path {
//        Path { path in
//            let width = geometry.size.width
//            let height = geometry.size.height
//            let stepX = width / CGFloat(data.count - 1)
//            
//            let minValue = data.map(\.value).min() ?? 0
//            let maxValue = data.map(\.value).max() ?? 1
//            let valueRange = maxValue - minValue
//            
//            // Convert data points to CGPoints
//            var points: [CGPoint] = []
//            for (index, point) in data.enumerated() {
//                let x = CGFloat(index) * stepX
//                let normalizedValue = valueRange > 0 ? (point.value - minValue) / valueRange : 0
//                let y = height - (normalizedValue * height)
//                points.append(CGPoint(x: x, y: y))
//            }
//            
//            guard points.count > 1 else { return }
//            
//            // Start at first point
//            path.move(to: points[0])
//            
//            // Create smooth curves between points (original implementation)
//            for i in 1..<points.count {
//                let currentPoint = points[i]
//                let previousPoint = points[i - 1]
//                
//                // Calculate control points for smooth curve (original logic)
//                let controlPoint1: CGPoint
//                let controlPoint2: CGPoint
//                
//                if i == 1 {
//                    // First curve
//                    controlPoint1 = CGPoint(
//                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
//                        y: previousPoint.y
//                    )
//                    controlPoint2 = CGPoint(
//                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
//                        y: currentPoint.y
//                    )
//                } else if i == points.count - 1 {
//                    // Last curve
//                    controlPoint1 = CGPoint(
//                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
//                        y: previousPoint.y
//                    )
//                    controlPoint2 = CGPoint(
//                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
//                        y: currentPoint.y
//                    )
//                } else {
//                    // Middle curves - use neighboring points for smoother transitions
//                    let nextPoint = points[i + 1]
//                    let prevPrevPoint = points[i - 2]
//                    
//                    controlPoint1 = CGPoint(
//                        x: previousPoint.x + (currentPoint.x - prevPrevPoint.x) * 0.15,
//                        y: previousPoint.y + (currentPoint.y - prevPrevPoint.y) * 0.15
//                    )
//                    controlPoint2 = CGPoint(
//                        x: currentPoint.x - (nextPoint.x - previousPoint.x) * 0.15,
//                        y: currentPoint.y - (nextPoint.y - previousPoint.y) * 0.15
//                    )
//                }
//                
//                // Add cubic curve
//                path.addCurve(
//                    to: currentPoint,
//                    control1: controlPoint1,
//                    control2: controlPoint2
//                )
//            }
//        }
//    }
//    
//    private func areaPath(in geometry: GeometryProxy) -> Path {
//        Path { path in
//            let width = geometry.size.width
//            let height = geometry.size.height
//            let stepX = width / CGFloat(data.count - 1)
//            
//            let minValue = data.map(\.value).min() ?? 0
//            let maxValue = data.map(\.value).max() ?? 1
//            let valueRange = maxValue - minValue
//            
//            // Convert data points to CGPoints
//            var points: [CGPoint] = []
//            for (index, point) in data.enumerated() {
//                let x = CGFloat(index) * stepX
//                let normalizedValue = valueRange > 0 ? (point.value - minValue) / valueRange : 0
//                let y = height - (normalizedValue * height)
//                points.append(CGPoint(x: x, y: y))
//            }
//            
//            guard points.count > 1 else { return }
//            
//            // Start from bottom left
//            path.move(to: CGPoint(x: 0, y: height))
//            
//            // Move to first point
//            path.addLine(to: points[0])
//            
//            // Create smooth curves between points (original implementation)
//            for i in 1..<points.count {
//                let currentPoint = points[i]
//                let previousPoint = points[i - 1]
//                
//                // Calculate control points for smooth curve (original logic)
//                let controlPoint1: CGPoint
//                let controlPoint2: CGPoint
//                
//                if i == 1 {
//                    // First curve
//                    controlPoint1 = CGPoint(
//                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
//                        y: previousPoint.y
//                    )
//                    controlPoint2 = CGPoint(
//                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
//                        y: currentPoint.y
//                    )
//                } else if i == points.count - 1 {
//                    // Last curve
//                    controlPoint1 = CGPoint(
//                        x: previousPoint.x + (currentPoint.x - previousPoint.x) * 0.3,
//                        y: previousPoint.y
//                    )
//                    controlPoint2 = CGPoint(
//                        x: currentPoint.x - (currentPoint.x - previousPoint.x) * 0.3,
//                        y: currentPoint.y
//                    )
//                } else {
//                    // Middle curves - use neighboring points for smoother transitions
//                    let nextPoint = points[i + 1]
//                    let prevPrevPoint = points[i - 2]
//                    
//                    controlPoint1 = CGPoint(
//                        x: previousPoint.x + (currentPoint.x - prevPrevPoint.x) * 0.15,
//                        y: previousPoint.y + (currentPoint.y - prevPrevPoint.y) * 0.15
//                    )
//                    controlPoint2 = CGPoint(
//                        x: currentPoint.x - (nextPoint.x - previousPoint.x) * 0.15,
//                        y: currentPoint.y - (nextPoint.y - previousPoint.y) * 0.15
//                    )
//                }
//                
//                // Add cubic curve
//                path.addCurve(
//                    to: currentPoint,
//                    control1: controlPoint1,
//                    control2: controlPoint2
//                )
//            }
//            
//            // Close the path at bottom right
//            path.addLine(to: CGPoint(x: width, y: height))
//            path.closeSubpath()
//        }
//    }
//    
//    private func selectedPointIndicator(at index: Int, in geometry: GeometryProxy) -> some View {
//        // Safely check if index is within bounds
//        guard index >= 0 && index < data.count else {
//            return AnyView(EmptyView())
//        }
//        
//        let width = geometry.size.width
//        let height = geometry.size.height
//        let stepX = width / CGFloat(data.count - 1)
//        
//        let minValue = data.map(\.value).min() ?? 0
//        let maxValue = data.map(\.value).max() ?? 1
//        let valueRange = maxValue - minValue
//        
//        // Calculate the exact position on the curve
//        let curvePosition = calculateCurvePosition(at: index, stepX: stepX, height: height, minValue: minValue, valueRange: valueRange)
//        
//        // Safely access the data point
//        let dataPoint = data[index]
//        
//        // Determine color based on trend
//        let trendColor: Color = {
//            if index > 0 {
//                return dataPoint.value >= data[index - 1].value ? .green : .red
//            }
//            return .green
//        }()
//        
//        return AnyView(
//            ZStack {
//                // Vertical line
//                Rectangle()
//                    .fill(Color.white)
//                    .frame(width: 1)
//                    .position(x: curvePosition.x, y: height / 2)
//                
//                // Point circle with trend color
//                Circle()
//                    .fill(trendColor)
//                    .frame(width: 8, height: 8)
//                    .overlay(
//                        Circle()
//                            .stroke(Color.white, lineWidth: 2)
//                            .frame(width: 16, height: 16)
//                    )
//                    .position(x: curvePosition.x, y: curvePosition.y)
//                    .scaleEffect(1.2)
//                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)
//                
//                // Value label
//                VStack(spacing: 4) {
//                    Text(dataPoint.dateString)
//                        .font(.system(size: 12, weight: .medium))
//                        .foregroundColor(.gray)
//                    
//                    Text(formatValue(dataPoint.value))
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.black.opacity(0.8))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(trendColor, lineWidth: 1)
//                        )
//                )
//                .position(
//                    x: curvePosition.x > geometry.size.width - 100 ? curvePosition.x - 60 : curvePosition.x + 60,
//                    y: 30
//                )
//                .animation(.easeInOut(duration: 0.3), value: selectedIndex)
//            }
//        )
//    }
//    
//    private func dragOverlay(in geometry: GeometryProxy) -> some View {
//        Rectangle()
//            .fill(Color.clear)
//            .contentShape(Rectangle())
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { value in
//                        let width = geometry.size.width
//                        let stepX = width / CGFloat(data.count - 1)
//                        let newIndex = Int(round(value.location.x / stepX))
//                        
//                        if newIndex >= 0 && newIndex < data.count {
//                            // Smooth transition between selected points
//                            if selectedIndex != newIndex {
//                                withAnimation(.easeInOut(duration: 0.2)) {
//                                    selectedIndex = newIndex
//                                }
//                                
//                                // Add subtle haptic feedback
//                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//                                impactFeedback.prepare()
//                                impactFeedback.impactOccurred()
//                            }
//                        }
//                        dragLocation = value.location
//                    }
//                    .onEnded { _ in
//                        // Keep the selected point visible with smooth transition
//                    }
//            )
//    }
//    
//    private func formatValue(_ value: Double) -> String {
//        switch currency {
//        case .inr:
//            return "₹ \(String(format: "%.0f", value))"
//        case .btc:
//            // Convert INR to BTC using approximate rate
//            let btcValue = value / 7562502.14 // Using BTC price from mock data
//            return "₿ \(String(format: "%.6f", btcValue))"
//        }
//    }
//}
//
//#Preview {
//    ZStack {
//        Color.black.ignoresSafeArea()
//        
//        VStack {
//            ChartView(data: ChartDataPoint.mockData, currency: .inr)
//                .padding()
//            
//            Spacer()
//        }
//    }
//}

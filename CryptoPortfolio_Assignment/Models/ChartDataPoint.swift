//
//  ChartDataPoint.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import Foundation

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
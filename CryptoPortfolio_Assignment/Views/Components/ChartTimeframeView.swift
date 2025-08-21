//
//  ChartTimeframeView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct ChartTimeframeView: View {
    @Binding var selectedTimeframe: ChartTimeframe
    let onTimeframeSelected: (ChartTimeframe) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                Button(action: {
                    onTimeframeSelected(timeframe)
                }) {
                    Text(timeframe.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedTimeframe == timeframe ? 
                                       Color(red: 225/255, green: 225/255, blue: 225/255, opacity: 0.8) : 
                                       Color(red: 119/255, green: 119/255, blue: 119/255, opacity: 0.8))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(width: 44)
                        .background(Color(red: 26/255, green: 25/255, blue: 27/255))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }
            }
        }
    }
}
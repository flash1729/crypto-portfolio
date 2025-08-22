//
//  SectionHeader.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let subtitle: String?
    
    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeader(title: "Recent Transactions")
        
        SectionHeader(
            title: "Transactions",
            subtitle: "Last 4 days"
        )
    }
    .background(Color.black)
    .padding()
}

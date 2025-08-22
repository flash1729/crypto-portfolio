//
//  BackButton.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
            .background(Color.clear)
            .clipShape(Circle())
        }
    }
}

#Preview {
    BackButton(action: {})
        .background(Color.black)
        .padding()
}

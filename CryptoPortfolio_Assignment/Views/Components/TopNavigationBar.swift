//
//  TopNavigationBar.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct TopNavigationBar: View {
    let menuAction: () -> Void
    let notificationAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: menuAction) {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: notificationAction) {
                Image(systemName: "bell")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 54) // Account for status bar
    }
}

#Preview {
    TopNavigationBar(
        menuAction: {},
        notificationAction: {}
    )
    .background(Color.black)
}

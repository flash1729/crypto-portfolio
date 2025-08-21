//
//  WalletView.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct WalletView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Text("Wallet")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("Coming Soon")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
    }
}
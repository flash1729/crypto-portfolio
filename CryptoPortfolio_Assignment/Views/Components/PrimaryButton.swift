//
//  PrimaryButton.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    let textColor: Color
    
    init(
        title: String,
        action: @escaping () -> Void,
        backgroundColor: Color = Color(hex: "1E4DDB"),
        textColor: Color = .white
    ) {
        self.title = title
        self.action = action
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(
            title: "Exchange",
            action: {}
        )
        
        PrimaryButton(
            title: "Cancel",
            action: {},
            backgroundColor: .gray,
            textColor: .white
        )
    }
    .padding()
    .background(Color.black)
}

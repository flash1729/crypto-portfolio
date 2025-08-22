//
//  AppBackground.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 22/08/25.
//

import SwiftUI

struct AppBackground: View {
    let content: AnyView
    
    init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            
            content
        }
    }
}

#Preview {
    AppBackground {
        VStack {
            Text("Sample Content")
                .foregroundColor(.white)
            
            Text("More content here")
                .foregroundColor(.gray)
        }
    }
}

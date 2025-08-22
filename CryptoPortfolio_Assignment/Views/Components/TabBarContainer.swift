//
//  TabBarContainer.swift
//  CryptoPortfolio_Assignment
//
//  Created by Aditya Medhane on 21/08/25.
//

import SwiftUI

struct TabBarContainer<Content: View>: View {
    let content: Content
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>,
         @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .ignoresSafeArea()
            
            // Always show the MaterialTabBar with all tabs
            MaterialTabBar(
                tabs: tabs.isEmpty ? TabBarItem.allCases : tabs,
                selection: $selection,
                localSelection: selection
            )
//            .padding(.horizontal, 20)
        }
        .onPreferenceChange(TabBarItemPreferenceKey.self) { value in
            self.tabs = value
        }
        .onAppear {
            // Ensure tabs are populated on appear
            if tabs.isEmpty {
                tabs = TabBarItem.allCases
            }
        }
    }
}

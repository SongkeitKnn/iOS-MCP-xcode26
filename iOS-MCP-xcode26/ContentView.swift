//
//  ContentView.swift
//  iOS-MCP-xcode26
//
//  Created by 667208 on 17/5/2569 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            AddPinScreen()
                .navigationTitle("Add PIN")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}

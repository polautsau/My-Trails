//
//  ContentView.swift
//  My Trails
//
//  Legacy preview bridging into RootScene for SwiftUI previews.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RootScene()
            .environmentObject(AppState())
            .environmentObject(LiquidGlassTheme())
    }
}

#Preview {
    ContentView()
}

//
//  My_TrailsApp.swift
//  My Trails
//
//  Created by OpenAI ChatGPT on 2024-10-25.
//

import SwiftUI

@main
struct My_TrailsApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var theme = LiquidGlassTheme()

    init() {
        AppBootstrap.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootScene()
                .environmentObject(appState)
                .environmentObject(theme)
                .task {
                    await appState.bootstrap()
                }
        }
    }
}

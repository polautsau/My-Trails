//
//  RootScene.swift
//  My Trails
//
//  Chooses between authentication, onboarding, and main app shell.
//

import SwiftUI

struct RootScene: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            MyTrailsUI.GradientBackground()
            switch appState.route {
            case .authentication:
                AuthenticationFlow()
            case .main:
                MainTabView()
            case .onboarding:
                OnboardingView()
            }
        }
        .overlay(alignment: .topTrailing) {
            if appState.isBootstrapping {
                ProgressView("Syncing...")
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding()
            }
        }
        .animation(.easeInOut, value: appState.route)
    }
}

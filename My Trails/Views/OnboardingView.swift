//
//  OnboardingView.swift
//  My Trails
//
//  Guides user through feature overview and permissions request.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Welcome to My Trails")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 16) {
                Label("3D Trail catalog with immersive visuals", systemImage: "cube")
                Label("Offline maps, weather, and elevation", systemImage: "arrow.down.circle")
                Label("Live GPS HUD with voice guidance", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
            }
            .font(.headline)
            .padding()
            .liquidGlassCard()

            MyTrailsUI.PrimaryButton(title: "Start Exploring", icon: "location.north") {
                withAnimation {
                    appState.route = .authentication
                }
            }
            Spacer()
        }
        .padding()
    }
}

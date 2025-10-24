//
//  LiquidGlassTheme.swift
//  My Trails
//
//  Implements the Liquid Glass visual language described in the TRD.
//

import SwiftUI

@MainActor
final class LiquidGlassTheme: ObservableObject {
    @Published var accentGradient: LinearGradient
    @Published var backgroundGradient: LinearGradient
    @Published var glassMaterial: Material
    @Published var glowColor: Color

    init(
        accentGradient: LinearGradient = LinearGradient(colors: [.cyan.opacity(0.8), .indigo], startPoint: .topLeading, endPoint: .bottomTrailing),
        backgroundGradient: LinearGradient = LinearGradient(colors: [.black, .blue.opacity(0.4)], startPoint: .top, endPoint: .bottom),
        glassMaterial: Material = .thinMaterial,
        glowColor: Color = .cyan
    ) {
        self.accentGradient = accentGradient
        self.backgroundGradient = backgroundGradient
        self.glassMaterial = glassMaterial
        self.glowColor = glowColor
    }
}

struct LiquidGlassBackground: ViewModifier {
    @EnvironmentObject private var theme: LiquidGlassTheme

    func body(content: Content) -> some View {
        content
            .padding()
            .background(theme.glassMaterial)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.08))
                    .shadow(color: theme.glowColor.opacity(0.6), radius: 24, x: 0, y: 12)
            )
    }
}

extension View {
    func liquidGlassCard() -> some View {
        modifier(LiquidGlassBackground())
    }
}

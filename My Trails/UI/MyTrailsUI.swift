//
//  MyTrailsUI.swift
//  My Trails
//
//  Shared SwiftUI components referenced across the TRD.
//

import SwiftUI

enum MyTrailsUI {
    struct PrimaryButton: View {
        var title: String
        var icon: String?
        var action: () -> Void

        @EnvironmentObject private var theme: LiquidGlassTheme

        var body: some View {
            Button(action: action) {
                HStack {
                    if let icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .font(.headline)
                        .bold()
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(theme.accentGradient)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: theme.glowColor.opacity(0.5), radius: 12, x: 0, y: 8)
            }
            .buttonStyle(.plain)
        }
    }

    struct Card: View {
        var title: String
        var subtitle: String
        var icon: String
        var content: AnyView

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Label(title, systemImage: icon)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                content
            }
            .liquidGlassCard()
        }
    }

    struct GradientBackground: View {
        @EnvironmentObject private var theme: LiquidGlassTheme

        var body: some View {
            Rectangle()
                .fill(theme.backgroundGradient)
                .ignoresSafeArea()
        }
    }

    struct IconBadge: View {
        var systemName: String
        var caption: String

        var body: some View {
            VStack(spacing: 6) {
                Image(systemName: systemName)
                    .font(.title)
                Text(caption)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .liquidGlassCard()
        }
    }

    struct NavBar: View {
        var title: String
        var trailing: AnyView?

        var body: some View {
            HStack {
                Text(title)
                    .font(.largeTitle.bold())
                Spacer()
                if let trailing {
                    trailing
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }

    struct StatsRow: View {
        var icon: String
        var title: String
        var value: String

        var body: some View {
            HStack {
                Label(title, systemImage: icon)
                Spacer()
                Text(value)
                    .font(.headline)
            }
            .padding(.vertical, 6)
        }
    }

    struct ProgressRing: View {
        var progress: Double
        var label: String

        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(AngularGradient(colors: [.cyan, .indigo, .purple], center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 80, height: 80)
                    Text("\(Int(progress * 100))%")
                        .font(.headline)
                }
                Text(label)
                    .font(.caption)
            }
            .padding()
            .liquidGlassCard()
        }
    }
}

//
//  ProfileView.swift
//  My Trails
//
//  Displays user profile, stats, achievements, and subscription options.
//

import SwiftUI
import Foundation

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                MyTrailsUI.NavBar(title: "Profile", trailing: AnyView(signOutButton))
                if let profile = viewModel.profile {
                    profileHeader(profile)
                    statsRow(profile)
                    achievementsSection(profile)
                } else {
                    Text("Sign in to see your progress")
                        .font(.headline)
                }
                subscriptionSection
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(MyTrailsUI.GradientBackground())
        .task {
            viewModel.bind(services: appState.services)
        }
        .sheet(isPresented: $viewModel.showSubscriptionSheet) {
            SubscriptionSheet(plans: viewModel.plans)
                .environmentObject(appState)
        }
    }

    private func profileHeader(_ profile: UserProfile) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 72))
            Text(profile.displayName)
                .font(.title2.bold())
            Text(profile.email)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(profile.tier == .premium ? "Premium" : "Free")
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(profile.tier == .premium ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2), in: Capsule())
        }
        .padding()
        .liquidGlassCard()
    }

    private func statsRow(_ profile: UserProfile) -> some View {
        HStack(spacing: 12) {
            MyTrailsUI.IconBadge(systemName: "figure.hiking", caption: "\(Int(profile.totalDistance.value)) km")
            MyTrailsUI.IconBadge(systemName: "mountain.2", caption: "\(Int(profile.totalElevation.value)) m")
            MyTrailsUI.IconBadge(systemName: "clock", caption: formatTime(profile.totalTime))
        }
    }

    private func achievementsSection(_ profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headline)
            if profile.achievements.isEmpty {
                Text("Complete hikes to earn achievements.")
                    .font(.caption)
            } else {
                ForEach(profile.achievements) { achievement in
                    HStack {
                        Image(systemName: achievement.iconName)
                        VStack(alignment: .leading) {
                            Text(achievement.title)
                            Text(achievement.description)
                                .font(.caption)
                        }
                        Spacer()
                        Text(achievement.earnedAt, style: .date)
                            .font(.caption2)
                    }
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }

    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium")
                .font(.headline)
            Text("$3.99/mo or $29.99/yr")
                .font(.subheadline)
            Text("Unlock offline unlimited, HD terrain, analytics, and ad-free experience.")
                .font(.caption)
            MyTrailsUI.PrimaryButton(title: "Upgrade", icon: "star.fill") {
                viewModel.showSubscriptionSheet = true
            }
        }
        .padding()
        .liquidGlassCard()
    }

    private var signOutButton: some View {
        Button(action: viewModel.signOut) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: time) ?? "0m"
    }
}

private struct SubscriptionSheet: View {
    var plans: [SubscriptionPlan]
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(plans) { plan in
                VStack(alignment: .leading, spacing: 8) {
                    Text(plan.type == .monthly ? "Monthly" : "Yearly")
                        .font(.headline)
                    Text("\(NSDecimalNumber(decimal: plan.price), formatter: currencyFormatter(for: plan.currencyCode))")
                    Text(plan.features.map(featureName).joined(separator: ", "))
                        .font(.caption)
                    Button("Subscribe") {
                        appState.hasPremiumAccess = true
                        appState.analytics.track(event: .subscriptionPurchased(plan.type))
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.vertical, 12)
            }
            .navigationTitle("Choose Plan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func currencyFormatter(for code: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        return formatter
    }

    private func featureName(_ feature: SubscriptionFeature) -> String {
        feature.rawValue
            .replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
            .capitalized
    }
}

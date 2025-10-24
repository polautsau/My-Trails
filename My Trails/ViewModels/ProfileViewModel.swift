//
//  ProfileViewModel.swift
//  My Trails
//
//  Handles user profile, achievements, and subscription state.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var plans: [SubscriptionPlan] = []
    @Published var showSubscriptionSheet = false

    private var authService: (any AuthenticationService)?

    func bind(services: ServiceProvider) {
        authService = services.authService
        Task { await loadProfile() }
        plans = [
            SubscriptionPlan(id: UUID(), type: .monthly, price: 3.99, currencyCode: "USD", features: [.offlineDownloadsUnlimited, .maps3D, .weatherForecasts7d, .adsFree, .analytics]),
            SubscriptionPlan(id: UUID(), type: .yearly, price: 29.99, currencyCode: "USD", features: [.offlineDownloadsUnlimited, .maps3D, .weatherForecasts7d, .adsFree, .analytics, .customMapStyles])
        ]
    }

    func loadProfile() async {
        profile = authService?.currentUser
    }

    func signOut() {
        Task {
            try? await authService?.signOut()
            profile = nil
        }
    }
}

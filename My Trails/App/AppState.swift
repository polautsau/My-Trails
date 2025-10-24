//
//  AppState.swift
//  My Trails
//
//  Manages global repositories, services, and application lifecycle events.
//

import Foundation
import Combine
import UIKit

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var repositories: RepositoryProvider
    @Published private(set) var services: ServiceProvider
    @Published var route: AppRoute = .authentication
    @Published var isBootstrapping = true
    @Published var onboardingCompleted = false
    @Published var hasPremiumAccess = false

    let analytics: AnalyticsService

    init(
        repositories: RepositoryProvider,
        services: ServiceProvider,
        analytics: AnalyticsService = ConsoleAnalyticsService()
    ) {
        self.repositories = repositories
        self.services = services
        self.analytics = analytics
    }

    @MainActor convenience init(
        analytics: AnalyticsService = ConsoleAnalyticsService()
    ) {
        self.init(
            repositories: RepositoryProvider.makeDefault(),
            services: ServiceProvider.makeDefault(),
            analytics: analytics
        )
    }

    func bootstrap() async {
        guard isBootstrapping else { return }

        do {
            try await repositories.bootstrap()
            try await services.bootstrap(repositories: repositories)
            try await Task.sleep(nanoseconds: 120_000_000) // allow splash effect
            if services.authService.isAuthenticated {
                route = .main
            }
            isBootstrapping = false
            analytics.track(event: .appLaunched)
        } catch {
            isBootstrapping = false
            analytics.track(error: error)
        }
    }

    func handle(deepLink: URL) {
        guard let destination = DeepLinkResolver.resolve(url: deepLink) else { return }
        route = destination.route
        analytics.track(event: .deepLinkOpened(destination.rawValue))
    }
}

enum AppRoute: Equatable {
    case authentication
    case main
    case onboarding
}

struct DeepLinkDestination: RawRepresentable, Equatable {
    let rawValue: String
    let route: AppRoute

    init?(rawValue: String) {
        switch rawValue {
        case "discover":
            self.rawValue = rawValue
            self.route = .main
        case "auth":
            self.rawValue = rawValue
            self.route = .authentication
        default:
            return nil
        }
    }

    init(rawValue: String, route: AppRoute) {
        self.rawValue = rawValue
        self.route = route
    }
}

enum AppBootstrap {
    static func configureAppearance() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .dark
    }
}

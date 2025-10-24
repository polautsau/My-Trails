//
//  ServiceProvider.swift
//  My Trails
//
//  Coordinates application services built on top of repositories.
//

import Foundation

@MainActor
struct ServiceProvider {
    let authService: any AuthenticationService
    let syncService: any SyncService
    let weatherService: any WeatherService
    let trackingService: any TrackingService
    let navigationService: any NavigationService

    init(
        authService: any AuthenticationService,
        syncService: any SyncService,
        weatherService: any WeatherService,
        trackingService: any TrackingService,
        navigationService: any NavigationService
    ) {
        self.authService = authService
        self.syncService = syncService
        self.weatherService = weatherService
        self.trackingService = trackingService
        self.navigationService = navigationService
    }

    static func makeDefault() -> ServiceProvider {
        ServiceProvider(
            authService: EmailFirstAuthenticationService(),
            syncService: FirebaseSyncService(),
            weatherService: OpenWeatherService(),
            trackingService: GPXTrackingService(),
            navigationService: GraphHopperNavigationService()
        )
    }

    func bootstrap(repositories: RepositoryProvider) async throws {
        try await authService.prepare()
        try await syncService.prepare(with: repositories)
        try await weatherService.prepare()
        try await trackingService.prepare()
        try await navigationService.prepare()
    }
}

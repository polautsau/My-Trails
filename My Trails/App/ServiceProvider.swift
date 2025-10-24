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
        authService: any AuthenticationService = EmailFirstAuthenticationService(),
        syncService: any SyncService = FirebaseSyncService(),
        weatherService: any WeatherService = OpenWeatherService(),
        trackingService: any TrackingService = GPXTrackingService(),
        navigationService: any NavigationService = GraphHopperNavigationService()
    ) {
        self.authService = authService
        self.syncService = syncService
        self.weatherService = weatherService
        self.trackingService = trackingService
        self.navigationService = navigationService
    }

    func bootstrap(repositories: RepositoryProvider) async throws {
        try await authService.prepare()
        try await syncService.prepare(with: repositories)
        try await weatherService.prepare()
        try await trackingService.prepare()
        try await navigationService.prepare()
    }
}

//
//  TrailDiscoveryViewModel.swift
//  My Trails
//
//  Handles search, filters, and map overlays for the trail catalog.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class TrailDiscoveryViewModel: ObservableObject {
    @Published var trails: [Trail] = []
    @Published var searchText: String = ""
    @Published var filterOptions: TrailFilterOptions = .default
    @Published var selectedTrail: Trail?
    @Published var isLoading = false
    @Published var weather: WeatherForecast?
    @Published var poi: [PointOfInterest] = []
    @Published var navigationRoute: NavigationRoute? = nil

    private var repository: (any TrailRepository)?
    private var poiRepository: (any POIRepository)?
    private var weatherService: (any WeatherService)?
    private var navigationService: (any NavigationService)?
    private var cancellables: Set<AnyCancellable> = []

    func bind(repositories: RepositoryProvider, services: ServiceProvider) {
        repository = repositories.trailRepository
        poiRepository = repositories.poiRepository
        weatherService = services.weatherService
        navigationService = services.navigationService
        Task { await loadTrails() }
        $searchText
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.loadTrails() }
            }
            .store(in: &cancellables)
    }

    func loadTrails() async {
        guard let repository else { return }
        do {
            isLoading = true
            let results = try await repository.searchTrails(query: searchText, filters: filterOptions)
            trails = results
            if let first = results.first {
                await select(trail: first)
            }
            isLoading = false
        } catch {
            isLoading = false
        }
    }

    func select(trail: Trail) async {
        selectedTrail = trail
        await loadMetadata(for: trail)
    }

    private func loadMetadata(for trail: Trail) async {
        let poiResult = try? await poiRepository?.fetchPOI(for: trail)
        let weatherResult = try? await weatherService?.forecast(for: trail.trailheadCoordinate, includeExtended: true)
        let navigationResult = try? await navigationService?.buildRoute(for: trail)
        self.poi = poiResult ?? []
        self.weather = weatherResult ?? self.weather
        self.navigationRoute = navigationResult ?? self.navigationRoute
    }
}

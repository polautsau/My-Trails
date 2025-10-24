//
//  LocalTrailRepository.swift
//  My Trails
//
//  Loads trail metadata from bundled JSON for offline-first experience.
//

import Foundation
import CoreLocation

@MainActor final class LocalTrailRepository: TrailRepository {
    private var cached: [Trail] = []

    func prepare() async throws {
        if cached.isEmpty {
            cached = try await loadBundledTrails()
        }
    }

    func listTrails() async throws -> [Trail] {
        if cached.isEmpty {
            cached = try await loadBundledTrails()
        }
        return cached
    }

    func fetchTrail(id: UUID) async throws -> Trail {
        if cached.isEmpty {
            cached = try await loadBundledTrails()
        }
        guard let trail = cached.first(where: { $0.id == id }) else {
            throw RepositoryError.notFound
        }
        return trail
    }

    func searchTrails(query: String, filters: TrailFilterOptions) async throws -> [Trail] {
        let results = try await listTrails().filter { trail in
            let matchesQuery = query.isEmpty || trail.name.localizedCaseInsensitiveContains(query)
            let matchesDifficulty = filters.difficulty.contains(trail.difficulty)
            let matchesDistance: Bool
            if let range = filters.distance {
                matchesDistance = range.contains(trail.distance.converted(to: .kilometers).value)
            } else {
                matchesDistance = true
            }
            let matchesElevation: Bool
            if let range = filters.elevationGain {
                matchesElevation = range.contains(trail.elevationGain.converted(to: .meters).value)
            } else {
                matchesElevation = true
            }
            let matchesFeatures = filters.features.isSubset(of: Set(trail.features)) || filters.features.isEmpty
            return matchesQuery && matchesDifficulty && matchesDistance && matchesElevation && matchesFeatures
        }
        return results
    }

    private func loadBundledTrails() async throws -> [Trail] {
        guard let url = Bundle.main.url(forResource: "trails", withExtension: "json") else {
            return SampleDataFactory.makeTrails()
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Trail].self, from: data)
    }
}

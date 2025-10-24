//
//  TrailRepository.swift
//  My Trails
//
//  Access layer for discovering and retrieving trails.
//

import Foundation

protocol TrailRepository {
    func prepare() async throws
    func listTrails() async throws -> [Trail]
    func fetchTrail(id: UUID) async throws -> Trail
    func searchTrails(query: String, filters: TrailFilterOptions) async throws -> [Trail]
}

struct TrailFilterOptions {
    var difficulty: Set<TrailDifficulty>
    var distance: ClosedRange<Double>?
    var elevationGain: ClosedRange<Double>?
    var features: Set<TrailFeature>
    var includeOfflineOnly: Bool

    static let `default` = TrailFilterOptions(
        difficulty: Set(TrailDifficulty.allCases),
        distance: nil,
        elevationGain: nil,
        features: Set(TrailFeature.allCases),
        includeOfflineOnly: false
    )
}

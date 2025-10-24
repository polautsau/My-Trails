//
//  Trail.swift
//  My Trails
//
//  Core data structures describing a hiking trail.
//

import Foundation
import CoreLocation

struct Trail: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var region: String
    var distance: Measurement<UnitLength>
    var elevationGain: Measurement<UnitLength>
    var difficulty: TrailDifficulty
    var thumbnailURL: URL?
    var preview3DURL: URL?
    var stats: TrailStats
    var mapTileset: OfflineTilesetReference
    var polyline: String
    var trailheadCoordinate: CLLocationCoordinate2D
    var features: [TrailFeature]
    var lastUpdated: Date

    init(
        id: UUID = UUID(),
        name: String,
        region: String,
        distance: Measurement<UnitLength>,
        elevationGain: Measurement<UnitLength>,
        difficulty: TrailDifficulty,
        thumbnailURL: URL? = nil,
        preview3DURL: URL? = nil,
        stats: TrailStats,
        mapTileset: OfflineTilesetReference,
        polyline: String,
        trailheadCoordinate: CLLocationCoordinate2D,
        features: [TrailFeature],
        lastUpdated: Date = .now
    ) {
        self.id = id
        self.name = name
        self.region = region
        self.distance = distance
        self.elevationGain = elevationGain
        self.difficulty = difficulty
        self.thumbnailURL = thumbnailURL
        self.preview3DURL = preview3DURL
        self.stats = stats
        self.mapTileset = mapTileset
        self.polyline = polyline
        self.trailheadCoordinate = trailheadCoordinate
        self.features = features
        self.lastUpdated = lastUpdated
    }
}

enum TrailDifficulty: String, Codable, CaseIterable {
    case easy
    case moderate
    case hard
    case expert
}

struct TrailStats: Codable, Hashable {
    var averageTime: TimeInterval
    var maxElevation: Measurement<UnitLength>
    var minElevation: Measurement<UnitLength>
    var surfaceType: SurfaceType
    var petFriendly: Bool
    var accessible: Bool
    var scenicScore: Int
}

enum SurfaceType: String, Codable {
    case dirt
    case gravel
    case rock
    case snow
}

enum TrailFeature: String, Codable, CaseIterable {
    case waterfall
    case lake
    case summit
    case forest
    case wildlife
    case campsite
}

struct OfflineTilesetReference: Codable, Hashable {
    var regionIdentifier: String
    var version: String
    var zoomRange: ClosedRange<Int>
    var tilePath: URL
}

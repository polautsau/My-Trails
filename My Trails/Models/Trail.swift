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

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case distanceMeters
        case elevationGainMeters
        case difficulty
        case thumbnailURL
        case preview3DURL
        case stats
        case mapTileset
        case polyline
        case trailheadLatitude
        case trailheadLongitude
        case features
        case lastUpdated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        region = try container.decode(String.self, forKey: .region)
        let distanceMeters = try container.decode(Double.self, forKey: .distanceMeters)
        distance = Measurement(value: distanceMeters, unit: .meters)
        let elevationMeters = try container.decode(Double.self, forKey: .elevationGainMeters)
        elevationGain = Measurement(value: elevationMeters, unit: .meters)
        difficulty = try container.decode(TrailDifficulty.self, forKey: .difficulty)
        thumbnailURL = try container.decodeIfPresent(URL.self, forKey: .thumbnailURL)
        preview3DURL = try container.decodeIfPresent(URL.self, forKey: .preview3DURL)
        stats = try container.decode(TrailStats.self, forKey: .stats)
        mapTileset = try container.decode(OfflineTilesetReference.self, forKey: .mapTileset)
        polyline = try container.decode(String.self, forKey: .polyline)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .trailheadLatitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .trailheadLongitude)
        trailheadCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        features = try container.decode([TrailFeature].self, forKey: .features)
        lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(region, forKey: .region)
        try container.encode(distance.converted(to: .meters).value, forKey: .distanceMeters)
        try container.encode(elevationGain.converted(to: .meters).value, forKey: .elevationGainMeters)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(thumbnailURL, forKey: .thumbnailURL)
        try container.encode(preview3DURL, forKey: .preview3DURL)
        try container.encode(stats, forKey: .stats)
        try container.encode(mapTileset, forKey: .mapTileset)
        try container.encode(polyline, forKey: .polyline)
        try container.encode(trailheadCoordinate.latitude, forKey: .trailheadLatitude)
        try container.encode(trailheadCoordinate.longitude, forKey: .trailheadLongitude)
        try container.encode(features, forKey: .features)
        try container.encode(lastUpdated, forKey: .lastUpdated)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

    private enum CodingKeys: String, CodingKey {
        case averageTime
        case maxElevationMeters
        case minElevationMeters
        case surfaceType
        case petFriendly
        case accessible
        case scenicScore
    }

    init(
        averageTime: TimeInterval,
        maxElevation: Measurement<UnitLength>,
        minElevation: Measurement<UnitLength>,
        surfaceType: SurfaceType,
        petFriendly: Bool,
        accessible: Bool,
        scenicScore: Int
    ) {
        self.averageTime = averageTime
        self.maxElevation = maxElevation
        self.minElevation = minElevation
        self.surfaceType = surfaceType
        self.petFriendly = petFriendly
        self.accessible = accessible
        self.scenicScore = scenicScore
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        averageTime = try container.decode(TimeInterval.self, forKey: .averageTime)
        let maxMeters = try container.decode(Double.self, forKey: .maxElevationMeters)
        maxElevation = Measurement(value: maxMeters, unit: .meters)
        let minMeters = try container.decode(Double.self, forKey: .minElevationMeters)
        minElevation = Measurement(value: minMeters, unit: .meters)
        surfaceType = try container.decode(SurfaceType.self, forKey: .surfaceType)
        petFriendly = try container.decode(Bool.self, forKey: .petFriendly)
        accessible = try container.decode(Bool.self, forKey: .accessible)
        scenicScore = try container.decode(Int.self, forKey: .scenicScore)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(averageTime, forKey: .averageTime)
        try container.encode(maxElevation.converted(to: .meters).value, forKey: .maxElevationMeters)
        try container.encode(minElevation.converted(to: .meters).value, forKey: .minElevationMeters)
        try container.encode(surfaceType, forKey: .surfaceType)
        try container.encode(petFriendly, forKey: .petFriendly)
        try container.encode(accessible, forKey: .accessible)
        try container.encode(scenicScore, forKey: .scenicScore)
    }
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

    private enum CodingKeys: String, CodingKey {
        case regionIdentifier
        case version
        case zoomLower
        case zoomUpper
        case tilePath
    }

    init(regionIdentifier: String, version: String, zoomRange: ClosedRange<Int>, tilePath: URL) {
        self.regionIdentifier = regionIdentifier
        self.version = version
        self.zoomRange = zoomRange
        self.tilePath = tilePath
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        regionIdentifier = try container.decode(String.self, forKey: .regionIdentifier)
        version = try container.decode(String.self, forKey: .version)
        let lower = try container.decode(Int.self, forKey: .zoomLower)
        let upper = try container.decode(Int.self, forKey: .zoomUpper)
        zoomRange = lower...upper
        tilePath = try container.decode(URL.self, forKey: .tilePath)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(regionIdentifier, forKey: .regionIdentifier)
        try container.encode(version, forKey: .version)
        try container.encode(zoomRange.lowerBound, forKey: .zoomLower)
        try container.encode(zoomRange.upperBound, forKey: .zoomUpper)
        try container.encode(tilePath, forKey: .tilePath)
    }
}

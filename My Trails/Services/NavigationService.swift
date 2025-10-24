//
//  NavigationService.swift
//  My Trails
//
//  Provides real-time navigation guidance leveraging GraphHopper/OpenRouteService.
//

import Foundation
import CoreLocation

protocol NavigationService {
    func prepare() async throws
    func buildRoute(for trail: Trail) async throws -> NavigationRoute
    func eta(for route: NavigationRoute, progress: Measurement<UnitLength>) async -> TimeInterval
}

struct NavigationRoute: Identifiable, Codable, Hashable {
    let id: UUID
    var segments: [NavigationSegment]
    var totalDistance: Measurement<UnitLength>
    var ascent: Measurement<UnitLength>
    var descent: Measurement<UnitLength>
    var expectedTime: TimeInterval

    private enum CodingKeys: String, CodingKey {
        case id
        case segments
        case totalDistanceMeters
        case ascentMeters
        case descentMeters
        case expectedTime
    }

    init(
        id: UUID = UUID(),
        segments: [NavigationSegment],
        totalDistance: Measurement<UnitLength>,
        ascent: Measurement<UnitLength>,
        descent: Measurement<UnitLength>,
        expectedTime: TimeInterval
    ) {
        self.id = id
        self.segments = segments
        self.totalDistance = totalDistance
        self.ascent = ascent
        self.descent = descent
        self.expectedTime = expectedTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        segments = try container.decode([NavigationSegment].self, forKey: .segments)
        let distance = try container.decode(Double.self, forKey: .totalDistanceMeters)
        totalDistance = Measurement(value: distance, unit: .meters)
        let ascentValue = try container.decode(Double.self, forKey: .ascentMeters)
        ascent = Measurement(value: ascentValue, unit: .meters)
        let descentValue = try container.decode(Double.self, forKey: .descentMeters)
        descent = Measurement(value: descentValue, unit: .meters)
        expectedTime = try container.decode(TimeInterval.self, forKey: .expectedTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(segments, forKey: .segments)
        try container.encode(totalDistance.converted(to: .meters).value, forKey: .totalDistanceMeters)
        try container.encode(ascent.converted(to: .meters).value, forKey: .ascentMeters)
        try container.encode(descent.converted(to: .meters).value, forKey: .descentMeters)
        try container.encode(expectedTime, forKey: .expectedTime)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct NavigationSegment: Identifiable, Codable, Hashable {
    let id: UUID
    var instruction: String
    var distance: Measurement<UnitLength>
    var coordinate: CLLocationCoordinate2D

    private enum CodingKeys: String, CodingKey {
        case id
        case instruction
        case distanceMeters
        case latitude
        case longitude
    }

    init(id: UUID = UUID(), instruction: String, distance: Measurement<UnitLength>, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.instruction = instruction
        self.distance = distance
        self.coordinate = coordinate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        instruction = try container.decode(String.self, forKey: .instruction)
        let distance = try container.decode(Double.self, forKey: .distanceMeters)
        self.distance = Measurement(value: distance, unit: .meters)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(instruction, forKey: .instruction)
        try container.encode(distance.converted(to: .meters).value, forKey: .distanceMeters)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

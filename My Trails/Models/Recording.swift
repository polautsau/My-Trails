//
//  Recording.swift
//  My Trails
//
//  Represents a recorded hike session.
//

import Foundation
import CoreLocation

struct TrailRecording: Identifiable, Codable, Hashable {
    enum State: Codable, Hashable {
        case idle
        case recording
        case paused
        case completed
    }

    let id: UUID
    var trailID: UUID?
    var startedAt: Date
    var updatedAt: Date
    var totalDistance: Measurement<UnitLength>
    var totalAscent: Measurement<UnitLength>
    var duration: TimeInterval
    var samples: [LocationSample]
    var notes: String?
    var state: State

    init(
        id: UUID = UUID(),
        trailID: UUID? = nil,
        startedAt: Date = .now,
        updatedAt: Date = .now,
        totalDistance: Measurement<UnitLength> = .init(value: 0, unit: .meters),
        totalAscent: Measurement<UnitLength> = .init(value: 0, unit: .meters),
        duration: TimeInterval = 0,
        samples: [LocationSample] = [],
        notes: String? = nil,
        state: State = .idle
    ) {
        self.id = id
        self.trailID = trailID
        self.startedAt = startedAt
        self.updatedAt = updatedAt
        self.totalDistance = totalDistance
        self.totalAscent = totalAscent
        self.duration = duration
        self.samples = samples
        self.notes = notes
        self.state = state
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case trailID
        case startedAt
        case updatedAt
        case totalDistanceMeters
        case totalAscentMeters
        case durationSeconds
        case samples
        case notes
        case state
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        trailID = try container.decodeIfPresent(UUID.self, forKey: .trailID)
        startedAt = try container.decode(Date.self, forKey: .startedAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        let distance = try container.decode(Double.self, forKey: .totalDistanceMeters)
        totalDistance = Measurement(value: distance, unit: .meters)
        let ascent = try container.decode(Double.self, forKey: .totalAscentMeters)
        totalAscent = Measurement(value: ascent, unit: .meters)
        duration = try container.decode(Double.self, forKey: .durationSeconds)
        samples = try container.decode([LocationSample].self, forKey: .samples)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        state = try container.decode(State.self, forKey: .state)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(trailID, forKey: .trailID)
        try container.encode(startedAt, forKey: .startedAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(totalDistance.converted(to: .meters).value, forKey: .totalDistanceMeters)
        try container.encode(totalAscent.converted(to: .meters).value, forKey: .totalAscentMeters)
        try container.encode(duration, forKey: .durationSeconds)
        try container.encode(samples, forKey: .samples)
        try container.encode(notes, forKey: .notes)
        try container.encode(state, forKey: .state)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct LocationSample: Identifiable, Codable, Hashable {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
    var altitude: Measurement<UnitLength>
    var timestamp: Date
    var horizontalAccuracy: CLLocationAccuracy
    var verticalAccuracy: CLLocationAccuracy

    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2D, altitude: Measurement<UnitLength>, timestamp: Date, horizontalAccuracy: CLLocationAccuracy, verticalAccuracy: CLLocationAccuracy) {
        self.id = id
        self.coordinate = coordinate
        self.altitude = altitude
        self.timestamp = timestamp
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case altitudeMeters
        case timestamp
        case horizontalAccuracy
        case verticalAccuracy
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let altitudeMeters = try container.decode(Double.self, forKey: .altitudeMeters)
        altitude = Measurement(value: altitudeMeters, unit: .meters)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        horizontalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .horizontalAccuracy)
        verticalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .verticalAccuracy)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude.converted(to: .meters).value, forKey: .altitudeMeters)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

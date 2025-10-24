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
}

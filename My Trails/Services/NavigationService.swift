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
}

struct NavigationSegment: Identifiable, Codable, Hashable {
    let id: UUID
    var instruction: String
    var distance: Measurement<UnitLength>
    var coordinate: CLLocationCoordinate2D
}

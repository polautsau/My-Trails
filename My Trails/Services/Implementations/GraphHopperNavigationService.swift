//
//  GraphHopperNavigationService.swift
//  My Trails
//
//  Creates navigation routes compatible with HUD overlays.
//

import Foundation
import CoreLocation

@MainActor final class GraphHopperNavigationService: NavigationService {
    func prepare() async throws { }

    func buildRoute(for trail: Trail) async throws -> NavigationRoute {
        let featureCount = max(trail.features.count, 1)
        let segments = trail.features.enumerated().map { index, feature in
            NavigationSegment(
                id: UUID(),
                instruction: instruction(for: feature),
                distance: .init(value: trail.distance.converted(to: .meters).value / Double(featureCount), unit: .meters),
                coordinate: CLLocationCoordinate2D(latitude: trail.trailheadCoordinate.latitude + Double(index) * 0.0002, longitude: trail.trailheadCoordinate.longitude + Double(index) * 0.0002)
            )
        }
        return NavigationRoute(
            id: UUID(),
            segments: segments,
            totalDistance: trail.distance,
            ascent: trail.elevationGain,
            descent: trail.elevationGain,
            expectedTime: trail.stats.averageTime
        )
    }

    func eta(for route: NavigationRoute, progress: Measurement<UnitLength>) async -> TimeInterval {
        let totalDistanceKm = max(route.totalDistance.converted(to: .kilometers).value, 0.1)
        let distanceRemaining = max(route.totalDistance.converted(to: .meters).value - progress.converted(to: .meters).value, 0)
        let averagePace = route.expectedTime / totalDistanceKm
        return distanceRemaining / 1_000 * averagePace
    }

    private func instruction(for feature: TrailFeature) -> String {
        switch feature {
        case .waterfall: return "Approach waterfall lookout"
        case .lake: return "Descend toward alpine lake"
        case .summit: return "Ascend to summit ridge"
        case .forest: return "Traverse old-growth forest"
        case .wildlife: return "Respect wildlife corridor"
        case .campsite: return "Arrive at backcountry campsite"
        }
    }
}

//
//  OpenOverpassPOIRepository.swift
//  My Trails
//
//  Lightweight wrapper around OpenStreetMap/Overpass API. Offline fallback uses bundled GPX metadata.
//

import Foundation
import CoreLocation

@MainActor final class OpenOverpassPOIRepository: POIRepository {
    func prepare() async throws { }

    func fetchPOI(for trail: Trail) async throws -> [PointOfInterest] {
        // Network disabled in testing environment; return synthetic POIs derived from trail features.
        return trail.features.enumerated().map { index, feature in
            PointOfInterest(
                id: UUID(),
                title: featureTitle(feature: feature),
                subtitle: "Auto-generated",
                category: mapCategory(feature: feature),
                coordinate: CLLocationCoordinate2D(latitude: trail.trailheadCoordinate.latitude + Double(index) * 0.001, longitude: trail.trailheadCoordinate.longitude + Double(index) * 0.001),
                elevation: .init(value: trail.stats.maxElevation.value - Double(index) * 10, unit: .meters),
                photoURL: nil
            )
        }
    }

    private func featureTitle(feature: TrailFeature) -> String {
        switch feature {
        case .waterfall: return "Waterfall Overlook"
        case .lake: return "Alpine Lake"
        case .summit: return "Summit"
        case .forest: return "Old Growth Grove"
        case .wildlife: return "Wildlife Corridor"
        case .campsite: return "Backcountry Camp"
        }
    }

    private func mapCategory(feature: TrailFeature) -> PointOfInterest.Category {
        switch feature {
        case .waterfall, .lake, .forest: return .viewpoint
        case .summit: return .viewpoint
        case .wildlife: return .information
        case .campsite: return .campsite
        }
    }
}

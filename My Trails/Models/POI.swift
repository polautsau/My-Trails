//
//  POI.swift
//  My Trails
//
//  Points of interest for trail overlays.
//

import Foundation
import CoreLocation

struct PointOfInterest: Identifiable, Codable, Hashable {
    enum Category: String, Codable, CaseIterable {
        case viewpoint
        case waterSource
        case campsite
        case shelter
        case caution
        case information
    }

    let id: UUID
    var title: String
    var subtitle: String?
    var category: Category
    var coordinate: CLLocationCoordinate2D
    var elevation: Measurement<UnitLength>
    var photoURL: URL?
}

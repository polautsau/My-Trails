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

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case category
        case latitude
        case longitude
        case elevationMeters
        case photoURL
    }

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        category: Category,
        coordinate: CLLocationCoordinate2D,
        elevation: Measurement<UnitLength>,
        photoURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.coordinate = coordinate
        self.elevation = elevation
        self.photoURL = photoURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        category = try container.decode(Category.self, forKey: .category)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let elevationMeters = try container.decode(Double.self, forKey: .elevationMeters)
        elevation = Measurement(value: elevationMeters, unit: .meters)
        photoURL = try container.decodeIfPresent(URL.self, forKey: .photoURL)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(category, forKey: .category)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(elevation.converted(to: .meters).value, forKey: .elevationMeters)
        try container.encode(photoURL, forKey: .photoURL)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
//  OfflinePackage.swift
//  My Trails
//
//  Describes offline bundles of data for a geographic region.
//

import Foundation

struct OfflinePackage: Identifiable, Codable, Hashable {
    enum Status: Codable, Hashable {
        case notDownloaded
        case downloading(progress: Double)
        case downloaded(Date)
        case outdated
    }

    let id: UUID
    var region: String
    var tileset: OfflineTilesetReference
    var elevationDataURL: URL
    var weatherCacheURL: URL
    var gpxFiles: [URL]
    var lastSynced: Date?
    var bytes: Int64
    var status: Status

    init(
        id: UUID = UUID(),
        region: String,
        tileset: OfflineTilesetReference,
        elevationDataURL: URL,
        weatherCacheURL: URL,
        gpxFiles: [URL],
        lastSynced: Date?,
        bytes: Int64,
        status: Status = .notDownloaded
    ) {
        self.id = id
        self.region = region
        self.tileset = tileset
        self.elevationDataURL = elevationDataURL
        self.weatherCacheURL = weatherCacheURL
        self.gpxFiles = gpxFiles
        self.lastSynced = lastSynced
        self.bytes = bytes
        self.status = status
    }
}

struct OfflinePackageManifest: Codable {
    var packages: [OfflinePackage]
    var generatedAt: Date
}

enum OfflineDirectory {
    static let root = URL(fileURLWithPath: "\(NSHomeDirectory())/Library/Application Support/Offline", isDirectory: true)

    static func path(for region: String) -> URL {
        root.appendingPathComponent(region, isDirectory: true)
    }
}

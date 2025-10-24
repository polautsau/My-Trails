//
//  FileSystemOfflineRepository.swift
//  My Trails
//
//  Stores offline packages under Application Support.
//

import Foundation

@MainActor final class FileSystemOfflineRepository: OfflinePackageRepository {
    private let manifestURL = OfflineDirectory.root.appendingPathComponent("manifest.json")
    private var cache: [OfflinePackage] = []

    func prepare() async throws {
        try FileManager.default.createDirectory(at: OfflineDirectory.root, withIntermediateDirectories: true)
        cache = try loadManifest()
    }

    func listPackages() async throws -> [OfflinePackage] {
        if cache.isEmpty {
            cache = try loadManifest()
        }
        return cache
    }

    func manifest(for region: String) async throws -> OfflinePackage? {
        try await listPackages().first { $0.region == region }
    }

    func save(package: OfflinePackage) async throws {
        if let index = cache.firstIndex(where: { $0.id == package.id }) {
            cache[index] = package
        } else {
            cache.append(package)
        }
        try persistManifest()
    }

    func removePackage(for region: String) async throws {
        cache.removeAll { $0.region == region }
        try persistManifest()
    }

    private func loadManifest() throws -> [OfflinePackage] {
        guard FileManager.default.fileExists(atPath: manifestURL.path) else { return [] }
        let data = try Data(contentsOf: manifestURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([OfflinePackage].self, from: data)
    }

    private func persistManifest() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(cache)
        try data.write(to: manifestURL, options: .atomic)
    }
}

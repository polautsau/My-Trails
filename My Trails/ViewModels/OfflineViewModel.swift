//
//  OfflineViewModel.swift
//  My Trails
//
//  Handles offline packages lifecycle.
//

import Foundation
import Combine

@MainActor
final class OfflineViewModel: ObservableObject {
    @Published var packages: [OfflinePackage] = []
    @Published var isSyncing = false
    @Published var error: String?

    private var repository: (any OfflinePackageRepository)?
    private var syncService: (any SyncService)?

    func bind(repositories: RepositoryProvider, services: ServiceProvider) {
        repository = repositories.offlineRepository
        syncService = services.syncService
        Task { await loadPackages() }
    }

    func loadPackages() async {
        guard let repository else { return }
        do {
            packages = try await repository.listPackages()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func download(region: String) {
        Task {
            guard let repository else { return }
            isSyncing = true
            let package = OfflinePackage(
                region: region,
                tileset: OfflineTilesetReference(
                    regionIdentifier: region,
                    version: "2024.10",
                    zoomRange: 6...16,
                    tilePath: OfflineDirectory.path(for: region).appendingPathComponent("tiles.mbtiles")
                ),
                elevationDataURL: OfflineDirectory.path(for: region).appendingPathComponent("elevation.tiff"),
                weatherCacheURL: OfflineDirectory.path(for: region).appendingPathComponent("weather.json"),
                gpxFiles: [],
                lastSynced: Date(),
                bytes: 280 * 1_024 * 1_024,
                status: .downloaded(Date())
            )
            try? await repository.save(package: package)
            try? await syncService?.syncTrailCatalog()
            await loadPackages()
            isSyncing = false
        }
    }

    func remove(region: String) {
        Task {
            guard let repository else { return }
            try? await repository.removePackage(for: region)
            await loadPackages()
        }
    }
}

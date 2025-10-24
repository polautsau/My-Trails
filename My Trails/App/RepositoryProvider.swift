//
//  RepositoryProvider.swift
//  My Trails
//
//  Encapsulates data repositories used across the app.
//

import Foundation

@MainActor
struct RepositoryProvider {
    let trailRepository: any TrailRepository
    let offlineRepository: any OfflinePackageRepository
    let poiRepository: any POIRepository

    init(
        trailRepository: any TrailRepository,
        offlineRepository: any OfflinePackageRepository,
        poiRepository: any POIRepository
    ) {
        self.trailRepository = trailRepository
        self.offlineRepository = offlineRepository
        self.poiRepository = poiRepository
    }

    @MainActor static func makeDefault() -> RepositoryProvider {
        RepositoryProvider(
            trailRepository: LocalTrailRepository(),
            offlineRepository: FileSystemOfflineRepository(),
            poiRepository: OpenOverpassPOIRepository()
        )
    }

    func bootstrap() async throws {
        try await trailRepository.prepare()
        try await offlineRepository.prepare()
        try await poiRepository.prepare()
    }
}

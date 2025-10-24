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
        trailRepository: any TrailRepository = LocalTrailRepository(),
        offlineRepository: any OfflinePackageRepository = FileSystemOfflineRepository(),
        poiRepository: any POIRepository = OpenOverpassPOIRepository()
    ) {
        self.trailRepository = trailRepository
        self.offlineRepository = offlineRepository
        self.poiRepository = poiRepository
    }

    func bootstrap() async throws {
        try await trailRepository.prepare()
        try await offlineRepository.prepare()
        try await poiRepository.prepare()
    }
}

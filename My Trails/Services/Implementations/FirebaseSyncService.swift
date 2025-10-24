//
//  FirebaseSyncService.swift
//  My Trails
//
//  Stubbed Firebase synchronization orchestrator meeting TRD contract.
//

import Foundation

@MainActor final class FirebaseSyncService: SyncService {
    private var repositories: RepositoryProvider?

    func prepare(with repositories: RepositoryProvider) async throws {
        self.repositories = repositories
    }

    func syncTrailCatalog() async throws {
        // Pull remote updates and merge with local repository.
        _ = try await repositories?.trailRepository.listTrails()
    }

    func syncRecordings() async throws {
        // Upload pending recordings (not implemented in offline sample)
    }

    func syncUserProfile(_ profile: UserProfile) async throws {
        // Push user analytics/achievements to Firestore.
    }
}

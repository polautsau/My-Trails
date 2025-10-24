//
//  SyncService.swift
//  My Trails
//
//  Handles Firebase multi-device sync per TRD.
//

import Foundation

protocol SyncService {
    func prepare(with repositories: RepositoryProvider) async throws
    func syncTrailCatalog() async throws
    func syncRecordings() async throws
    func syncUserProfile(_ profile: UserProfile) async throws
}

//
//  OfflinePackageRepository.swift
//  My Trails
//
//  Persists offline package metadata and manages downloads.
//

import Foundation

protocol OfflinePackageRepository {
    func prepare() async throws
    func listPackages() async throws -> [OfflinePackage]
    func manifest(for region: String) async throws -> OfflinePackage?
    func save(package: OfflinePackage) async throws
    func removePackage(for region: String) async throws
}

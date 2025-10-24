//
//  POIRepository.swift
//  My Trails
//
//  Points of interest repository backed by OpenOverpass.
//

import Foundation

protocol POIRepository {
    func prepare() async throws
    func fetchPOI(for trail: Trail) async throws -> [PointOfInterest]
}

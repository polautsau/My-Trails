//
//  FirebaseDataModel.swift
//  My Trails
//
//  Mirrors the Firestore collections described in the TRD.
//

import Foundation

struct FirestoreTrail: Codable {
    var id: String
    var name: String
    var region: String
    var stats: FirestoreStats
    var tileset: String
    var polyline: String
    var poiIDs: [String]
    var lastUpdated: Date
}

struct FirestoreStats: Codable {
    var distance: Double
    var ascent: Double
    var descent: Double
    var time: TimeInterval
}

struct FirestoreRecording: Codable {
    var id: String
    var userID: String
    var trailID: String?
    var startedAt: Date
    var stats: FirestoreStats
    var track: FirestoreTrack
}

struct FirestoreTrack: Codable {
    var uid: String
    var name: String
    var stats: FirestoreStats
    var polyline: String
}

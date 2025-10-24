//
//  TrackingService.swift
//  My Trails
//
//  Handles GPS recording, pause/resume, and HUD metrics.
//

import Foundation
import Combine

protocol TrackingService: AnyObject {
    var currentRecording: TrailRecording? { get }
    func prepare() async throws
    func startRecording(trailID: UUID?) async throws -> TrailRecording
    func pause() async throws
    func resume() async throws
    func stop() async throws -> TrailRecording
    func subscribeToSamples() -> AsyncStream<LocationSample>
}

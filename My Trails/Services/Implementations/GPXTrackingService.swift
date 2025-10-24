//
//  GPXTrackingService.swift
//  My Trails
//
//  Simulated GPS recording engine supporting pause/resume and GPX export.
//

import Foundation
import CoreLocation

@MainActor final class GPXTrackingService: TrackingService {
    private var recording: TrailRecording?
    private var streamContinuation: AsyncStream<LocationSample>.Continuation?

    var currentRecording: TrailRecording? { recording }

    func prepare() async throws {
        recording = nil
    }

    func startRecording(trailID: UUID?) async throws -> TrailRecording {
        let newRecording = TrailRecording(trailID: trailID, state: .recording)
        recording = newRecording
        Task { [weak self] in
            guard let self else { return }
            for index in 0..<512 {
                try await Task.sleep(nanoseconds: 200_000_000)
                await self.emitSample(index: index)
            }
        }
        return newRecording
    }

    func pause() async throws {
        guard var rec = recording else { return }
        rec.state = .paused
        recording = rec
    }

    func resume() async throws {
        guard var rec = recording else { return }
        rec.state = .recording
        recording = rec
    }

    func stop() async throws -> TrailRecording {
        guard var rec = recording else { throw TrackingError.noActiveRecording }
        rec.state = .completed
        rec.updatedAt = .now
        recording = nil
        streamContinuation?.finish()
        streamContinuation = nil
        return rec
    }

    func subscribeToSamples() -> AsyncStream<LocationSample> {
        AsyncStream { [weak self] continuation in
            Task { @MainActor in
                self?.streamContinuation = continuation
            }
            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in
                    self?.streamContinuation = nil
                }
            }
        }
    }

    private func emitSample(index: Int) async {
        guard var rec = recording, rec.state == .recording else { return }
        let sample = LocationSample(
            coordinate: CLLocationCoordinate2D(latitude: 47.6062 + Double(index) * 0.0001, longitude: -122.3321 + Double(index) * 0.0001),
            altitude: .init(value: 200 + Double(index) * 0.5, unit: .meters),
            timestamp: .now,
            horizontalAccuracy: 5,
            verticalAccuracy: 8
        )
        rec.samples.append(sample)
        rec.totalDistance = .init(value: rec.totalDistance.value + 12, unit: .meters)
        rec.totalAscent = .init(value: rec.totalAscent.value + 1, unit: .meters)
        rec.duration += 2
        rec.updatedAt = sample.timestamp
        recording = rec
        streamContinuation?.yield(sample)
    }
}

enum TrackingError: Error {
    case noActiveRecording
}

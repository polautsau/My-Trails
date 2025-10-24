//
//  RecordingViewModel.swift
//  My Trails
//
//  Manages live GPS recording HUD.
//

import Foundation
import Combine

@MainActor
final class RecordingViewModel: ObservableObject {
    @Published private(set) var recording: TrailRecording = TrailRecording()
    @Published var isRecording = false
    @Published var samples: [LocationSample] = []

    private var trackingService: (any TrackingService)?
    private var sampleTask: Task<Void, Never>?

    func bind(services: ServiceProvider) {
        trackingService = services.trackingService
    }

    func start(trailID: UUID?) {
        guard let trackingService, !isRecording else { return }
        Task {
            do {
                recording = try await trackingService.startRecording(trailID: trailID)
                isRecording = true
                listenForSamples()
            } catch {
                print("Recording error: \(error)")
            }
        }
    }

    func pause() {
        Task { try? await trackingService?.pause() }
    }

    func resume() {
        Task { try? await trackingService?.resume() }
    }

    func stop() {
        Task {
            if let result = try? await trackingService?.stop() {
                recording = result
                isRecording = false
                sampleTask?.cancel()
            }
        }
    }

    private func listenForSamples() {
        sampleTask?.cancel()
        guard let trackingService else { return }
        sampleTask = Task {
            for await sample in trackingService.subscribeToSamples() {
                samples.append(sample)
                recording.totalDistance = .init(value: recording.totalDistance.value + 12, unit: .meters)
                recording.totalAscent = .init(value: recording.totalAscent.value + 1, unit: .meters)
                recording.duration += 2
                recording.updatedAt = sample.timestamp
            }
        }
    }
}

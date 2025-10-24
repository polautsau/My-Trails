//
//  RecordView.swift
//  My Trails
//
//  Real-time recording HUD with voiceover cues placeholder.
//

import SwiftUI
import CoreLocation

struct RecordView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = RecordingViewModel()

    var body: some View {
        VStack(spacing: 24) {
            MyTrailsUI.NavBar(title: "Record", trailing: AnyView(settingsButton))
            MyTrailsUI.PrimaryButton(title: viewModel.isRecording ? "Mark Waypoint" : "Start Recording", icon: viewModel.isRecording ? "mappin.and.ellipse" : "record.circle") {
                if viewModel.isRecording {
                    // placeholder for waypoint capture
                } else {
                    viewModel.start(trailID: viewModel.recording.trailID)
                }
            }
            MapPreviewHUD(samples: viewModel.samples)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            statGrid
            controlBar
            Button(role: .destructive) {
                // Placeholder for emergency beacon
            } label: {
                Label("Send Emergency Beacon", systemImage: "exclamationmark.triangle")
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)

            if viewModel.isRecording {
                Text("Recording...")
                    .font(.headline)
                    .foregroundStyle(.red)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(MyTrailsUI.GradientBackground())
        .task {
            viewModel.bind(services: appState.services)
        }
    }

    private var statGrid: some View {
        HStack(spacing: 12) {
            MyTrailsUI.IconBadge(systemName: "figure.walk", caption: "\(Int(viewModel.recording.totalDistance.value)) m")
            MyTrailsUI.IconBadge(systemName: "arrow.up.right", caption: "\(Int(viewModel.recording.totalAscent.value)) m")
            MyTrailsUI.IconBadge(systemName: "clock", caption: formattedDuration)
        }
    }

    private var controlBar: some View {
        HStack(spacing: 16) {
            Button(action: viewModel.pause) {
                Label("Pause", systemImage: "pause.circle")
            }
            .buttonStyle(.borderedProminent)

            Button(action: viewModel.resume) {
                Label("Resume", systemImage: "play.circle")
            }
            .buttonStyle(.bordered)

            Button(action: viewModel.stop) {
                Label("Stop", systemImage: "stop.circle")
            }
            .buttonStyle(.bordered)
        }
        .font(.headline)
    }

    private var settingsButton: some View {
        Button {
            // future: show HUD settings
        } label: {
            Image(systemName: "gearshape")
        }
    }

    private var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: viewModel.recording.duration) ?? "0m"
    }
}

private struct MapPreviewHUD: View {
    var samples: [LocationSample]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.2)
            VStack(alignment: .leading) {
                Text("HUD View")
                    .font(.headline)
                    .padding()
                Spacer()
                Text("Samples: \(samples.count)")
                    .font(.caption)
                    .padding()
            }
            Toggle(isOn: .constant(true)) {
                Text("Voice")
            }
            .labelsHidden()
            .padding()
            .background(.ultraThinMaterial, in: Capsule())
            .padding()
        }
    }
}

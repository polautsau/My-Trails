//
//  OfflineDownloadsView.swift
//  My Trails
//
//  Manages offline packages per TRD download structure.
//

import SwiftUI

struct OfflineDownloadsView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OfflineViewModel()
    @State private var regionInput: String = "PNW"

    var body: some View {
        VStack(spacing: 24) {
            MyTrailsUI.NavBar(title: "Offline", trailing: AnyView(syncButton))
            VStack(alignment: .leading, spacing: 12) {
                Text("Offline package root")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(OfflineDirectory.root.path)
                    .font(.footnote)
            }
            .padding()
            .liquidGlassCard()

            TextField("Region identifier", text: $regionInput)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

            MyTrailsUI.PrimaryButton(title: "Download Region", icon: "arrow.down.circle") {
                viewModel.download(region: regionInput)
            }

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.packages) { package in
                        OfflinePackageRow(package: package) {
                            viewModel.remove(region: package.region)
                        }
                    }
                }
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(MyTrailsUI.GradientBackground())
        .task {
            viewModel.bind(repositories: appState.repositories, services: appState.services)
        }
        .overlay(alignment: .topTrailing) {
            if viewModel.isSyncing {
                ProgressView("Syncing")
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding()
            }
        }
    }

    private var syncButton: some View {
        Button {
            Task { await viewModel.loadPackages() }
        } label: {
            Image(systemName: "arrow.clockwise")
        }
    }
}

private struct OfflinePackageRow: View {
    var package: OfflinePackage
    var removeAction: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(package.region)
                    .font(.headline)
                Text("Tileset: \(package.tileset.version)")
                    .font(.caption)
                Text("Size: \(package.bytes / 1_048_576) MB")
                    .font(.caption)
                Text(statusText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(spacing: 8) {
                Button(role: .destructive, action: removeAction) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .liquidGlassCard()
    }

    private var statusText: String {
        switch package.status {
        case .notDownloaded: return "Not downloaded"
        case .downloading(let progress): return "Downloading... \(Int(progress * 100))%"
        case .downloaded(let date): return "Downloaded on \(date.formatted())"
        case .outdated: return "Update available"
        }
    }
}

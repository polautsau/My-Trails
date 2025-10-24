//
//  TrailDiscoveryView.swift
//  My Trails
//
//  Browse and filter curated hiking trails with 3D visualization placeholder.
//

import SwiftUI
import CoreLocation

struct TrailDiscoveryView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = TrailDiscoveryViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                searchField
                trailCarousel
                if !appState.hasPremiumAccess {
                    Text("Upgrade for HD terrain and offline 3D maps.")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }
                if let weather = viewModel.weather {
                    WeatherSummaryView(forecast: weather)
                }
                if !viewModel.poi.isEmpty {
                    POIGridView(points: viewModel.poi)
                }
                if let selected = viewModel.selectedTrail {
                    TrailAnalyticsView(trail: selected)
                }
                if let route = viewModel.navigationRoute {
                    NavigationPreviewView(route: route)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(MyTrailsUI.GradientBackground())
        .task {
            viewModel.bind(repositories: appState.repositories, services: appState.services)
        }
        .overlay(alignment: .topTrailing) {
            if viewModel.isLoading {
                ProgressView()
                    .padding(12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding()
            }
        }
    }

    private var searchField: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search trails", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(TrailDifficulty.allCases.enumerated()), id: \.offset) { _, diff in
                        FilterChip(title: diff.rawValue.capitalized, isSelected: viewModel.filterOptions.difficulty.contains(diff)) {
                            toggleDifficulty(diff)
                        }
                    }
                }
            }
        }
    }

    private var trailCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.trails) { trail in
                    TrailCard(trail: trail, isSelected: viewModel.selectedTrail?.id == trail.id)
                        .onTapGesture {
                            Task { await viewModel.select(trail: trail) }
                            appState.analytics.track(event: .trailSelected(trail.id))
                        }
                }
            }
            .padding(.vertical)
        }
    }

    private func toggleDifficulty(_ difficulty: TrailDifficulty) {
        if viewModel.filterOptions.difficulty.contains(difficulty) {
            viewModel.filterOptions.difficulty.remove(difficulty)
        } else {
            viewModel.filterOptions.difficulty.insert(difficulty)
        }
        Task { await viewModel.loadTrails() }
    }
}

private struct FilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(isSelected ? Color.cyan.opacity(0.4) : Color.white.opacity(0.1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct TrailCard: View {
    var trail: Trail
    var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                MapPreviewView(trail: trail)
                    .frame(width: 260, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                LinearGradient(colors: [.black.opacity(0.8), .clear], startPoint: .bottom, endPoint: .top)
                    .frame(height: 80)
                VStack(alignment: .leading) {
                    Text(trail.name)
                        .font(.headline)
                    Text(trail.region)
                        .font(.caption)
                }
                .padding()
                .foregroundStyle(Color.white)
            }
            HStack {
                Label("\(trail.distance.value, specifier: "%.1f") km", systemImage: "figure.walk")
                Spacer()
                Label("\(Int(trail.elevationGain.value)) m", systemImage: "mountain.2")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(isSelected ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
        )
    }
}

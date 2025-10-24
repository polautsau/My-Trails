//
//  POIGridView.swift
//  My Trails
//
//  Displays POIs for a selected trail.
//

import SwiftUI

struct POIGridView: View {
    var points: [PointOfInterest]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Points of Interest")
                .font(.headline)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(points) { poi in
                    VStack(alignment: .leading, spacing: 8) {
                        Label(poi.title, systemImage: icon(for: poi.category))
                            .font(.subheadline)
                        if let subtitle = poi.subtitle {
                            Text(subtitle)
                                .font(.caption)
                        }
                        Text("Elevation: \(Int(poi.elevation.value)) m")
                            .font(.caption2)
                    }
                    .padding()
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }

    private func icon(for category: PointOfInterest.Category) -> String {
        switch category {
        case .viewpoint: return "binoculars"
        case .waterSource: return "drop"
        case .campsite: return "tent"
        case .shelter: return "house"
        case .caution: return "exclamationmark.triangle"
        case .information: return "info.circle"
        }
    }
}

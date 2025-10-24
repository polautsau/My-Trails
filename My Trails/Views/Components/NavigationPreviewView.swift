//
//  NavigationPreviewView.swift
//  My Trails
//
//  Visualizes navigation instructions using the NavigationService.
//

import SwiftUI

struct NavigationPreviewView: View {
    var route: NavigationRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Route Overview")
                .font(.headline)
            Text("Distance: \(route.totalDistance.value, specifier: "%.1f") km")
                .font(.subheadline)
            Text("Ascent: \(Int(route.ascent.value)) m")
                .font(.caption)
            Divider()
            ForEach(route.segments) { segment in
                HStack {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond")
                    Text(segment.instruction)
                        .font(.caption)
                    Spacer()
                    Text("\(Int(segment.distance.value)) m")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }
}

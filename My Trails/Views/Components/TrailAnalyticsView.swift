//
//  TrailAnalyticsView.swift
//  My Trails
//
//  Presents distance, elevation, and map analytics per TRD.
//

import SwiftUI

struct TrailAnalyticsView: View {
    var trail: Trail

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trail Analytics")
                .font(.headline)
            MyTrailsUI.StatsRow(icon: "speedometer", title: "Avg Time", value: format(time: trail.stats.averageTime))
            MyTrailsUI.StatsRow(icon: "chart.bar", title: "Elevation", value: "\(Int(trail.stats.minElevation.value)) - \(Int(trail.stats.maxElevation.value)) m")
            MyTrailsUI.StatsRow(icon: "flame", title: "Scenic Score", value: "\(trail.stats.scenicScore)/10")
            MyTrailsUI.StatsRow(icon: "pawprint", title: "Pet friendly", value: trail.stats.petFriendly ? "Yes" : "No")
            MyTrailsUI.StatsRow(icon: "figure.roll", title: "Accessible", value: trail.stats.accessible ? "Yes" : "No")
        }
        .padding()
        .liquidGlassCard()
    }

    private func format(time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: time) ?? "--"
    }
}

//
//  WeatherSummaryView.swift
//  My Trails
//
//  Visualizes 48h/7d weather forecasts.
//

import SwiftUI

struct WeatherSummaryView: View {
    var forecast: WeatherForecast

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather Forecast")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(forecast.hourly.prefix(12)) { hour in
                        VStack {
                            Text(hour.timestamp, style: .time)
                                .font(.caption)
                            Image(systemName: icon(for: hour.condition))
                            Text("\(hour.temperature.value, specifier: "%.0f")°")
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            Divider()
            HStack {
                ForEach(forecast.daily) { day in
                    VStack {
                        Text(day.date, style: .date)
                            .font(.caption2)
                        Image(systemName: icon(for: day.condition))
                        Text("\(day.minTemperature.value, specifier: "%.0f")° / \(day.maxTemperature.value, specifier: "%.0f")°")
                            .font(.caption)
                        Text(day.avalancheRisk.rawValue.capitalized)
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                    .padding()
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding()
        .liquidGlassCard()
    }

    private func icon(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear: return "sun.max"
        case .partlyCloudy: return "cloud.sun"
        case .cloudy: return "cloud"
        case .rain: return "cloud.rain"
        case .storm: return "cloud.bolt.rain"
        case .snow: return "cloud.snow"
        case .fog: return "cloud.fog"
        }
    }
}

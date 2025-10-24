//
//  SampleDataFactory.swift
//  My Trails
//
//  Generates placeholder content matching TRD scenarios when network assets are unavailable.
//

import Foundation
import CoreLocation

enum SampleDataFactory {
    static func makeTrails() -> [Trail] {
        let base = OfflineDirectory.root
        return [
            Trail(
                name: "Liquid Glass Ridge",
                region: "Pacific Northwest",
                distance: .init(value: 12.4, unit: .kilometers),
                elevationGain: .init(value: 820, unit: .meters),
                difficulty: .hard,
                stats: TrailStats(
                    averageTime: 4 * 3_600,
                    maxElevation: .init(value: 2100, unit: .meters),
                    minElevation: .init(value: 1250, unit: .meters),
                    surfaceType: .rock,
                    petFriendly: false,
                    accessible: false,
                    scenicScore: 9
                ),
                mapTileset: OfflineTilesetReference(
                    regionIdentifier: "pnw",
                    version: "2024.10",
                    zoomRange: 8...17,
                    tilePath: base.appendingPathComponent("pnw/tiles.mbtiles")
                ),
                polyline: "_p~iF~ps|U_ulLnnqC_mqNvxq`@",
                trailheadCoordinate: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321),
                features: [.summit, .forest, .wildlife],
                lastUpdated: .now
            ),
            Trail(
                name: "Starlit Basin Loop",
                region: "Alpine Lakes",
                distance: .init(value: 8.3, unit: .kilometers),
                elevationGain: .init(value: 540, unit: .meters),
                difficulty: .moderate,
                stats: TrailStats(
                    averageTime: 3 * 3_600,
                    maxElevation: .init(value: 1850, unit: .meters),
                    minElevation: .init(value: 1250, unit: .meters),
                    surfaceType: .dirt,
                    petFriendly: true,
                    accessible: false,
                    scenicScore: 7
                ),
                mapTileset: OfflineTilesetReference(
                    regionIdentifier: "alpine",
                    version: "2024.10",
                    zoomRange: 9...16,
                    tilePath: base.appendingPathComponent("alpine/tiles.mbtiles")
                ),
                polyline: "_ifpFz}}uO_hqNvxq`@",
                trailheadCoordinate: CLLocationCoordinate2D(latitude: 47.401, longitude: -121.567),
                features: [.lake, .campsite, .forest],
                lastUpdated: .now
            )
        ]
    }

    static func makeWeather() -> WeatherForecast {
        let location = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        let hourly = (0..<24).map { index in
            HourlyWeather(
                timestamp: Calendar.current.date(byAdding: .hour, value: index, to: .now)!,
                temperature: .init(value: Double.random(in: -2...18), unit: .celsius),
                precipitationProbability: Double.random(in: 0...0.6),
                windSpeed: .init(value: Double.random(in: 1...8), unit: .metersPerSecond),
                visibility: .init(value: Double.random(in: 2_000...10_000), unit: .meters),
                condition: WeatherCondition.allCases.randomElement() ?? .clear
            )
        }
        let daily = (0..<7).map { index in
            DailyWeather(
                id: UUID(),
                date: Calendar.current.date(byAdding: .day, value: index, to: .now)!,
                sunrise: .now,
                sunset: .now,
                minTemperature: .init(value: Double.random(in: -5...8), unit: .celsius),
                maxTemperature: .init(value: Double.random(in: 5...25), unit: .celsius),
                condition: WeatherCondition.allCases.randomElement() ?? .clear,
                avalancheRisk: AvalancheRisk.allCases.randomElement() ?? .low
            )
        }
        return WeatherForecast(location: location, hourly: hourly, daily: daily)
    }
}

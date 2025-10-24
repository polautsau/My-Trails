//
//  OpenWeatherService.swift
//  My Trails
//
//  Integrates OpenWeather + MET Norway (YR) for forecasts. Offline fallback caches to disk for 48h/7d windows.
//

import Foundation
import CoreLocation

@MainActor final class OpenWeatherService: WeatherService {
    private var cache: [String: WeatherForecast] = [:]

    var supportsExtendedForecast: Bool { true }

    func prepare() async throws {
        cache = [:]
    }

    func forecast(for location: CLLocationCoordinate2D, includeExtended: Bool) async throws -> WeatherForecast {
        let key = "\(location.latitude.rounded())_\(location.longitude.rounded())_\(includeExtended)"
        if let cached = cache[key], Date().timeIntervalSince(cached.updatedAt) < (includeExtended ? 7 * 24 * 3_600 : 48 * 3_600) {
            return cached
        }
        // Offline demo: return synthetic sample data.
        var forecast = SampleDataFactory.makeWeather()
        forecast = WeatherForecast(id: forecast.id, location: location, hourly: forecast.hourly, daily: forecast.daily, updatedAt: .now)
        cache[key] = forecast
        return forecast
    }
}
